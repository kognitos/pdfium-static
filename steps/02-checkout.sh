#!/bin/bash -eux

PDFium_URL='https://pdfium.googlesource.com/pdfium.git'
OS=${PDFium_TARGET_OS:?}

# Clone
gclient config --unmanaged "$PDFium_URL" \
  --custom-var "checkout_configuration=small"
echo "target_os = [ '$OS' ]" >> .gclient

# pdfium's DEPS has an unconditional cipd dep on infra/rbe/client/<platform>,
# but that package isn't published for linux-arm64 hosts — gclient sync
# would abort there. We never invoke remote execution during the build,
# so null the dep out via custom_deps.
python3 <<'END'
import re, pathlib
p = pathlib.Path('.gclient')
src = p.read_text()
# Insert custom_deps into the pdfium solution entry.
src = re.sub(
    r'("name"\s*:\s*"pdfium",)',
    r'\1\n    "custom_deps": {"pdfium/buildtools/reclient": None},',
    src,
    count=1,
)
p.write_text(src)
END


# Reset
for FOLDER in pdfium pdfium/build pdfium/v8 pdfium/third_party/libjpeg_turbo pdfium/base/allocator/partition_allocator; do
  if [ -e "$FOLDER" ]; then
    git -C $FOLDER reset --hard
    git -C $FOLDER clean -df
  fi
done

gclient sync -r "origin/${PDFium_BRANCH:-main}" --no-history --shallow
