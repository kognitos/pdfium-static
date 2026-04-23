#!/bin/bash -eux

PDFium_URL='https://pdfium.googlesource.com/pdfium.git'
OS=${PDFium_TARGET_OS:?}
BRANCH=${PDFium_BRANCH:-main}

# Clone
gclient config --unmanaged "$PDFium_URL" \
  --custom-var "checkout_configuration=small"
echo "target_os = [ '$OS' ]" >> .gclient

# Fetch just the pdfium repo first (gclient would do this plus cipd deps
# in one shot, but we need to edit DEPS before cipd resolves anything).
if [ ! -d pdfium ]; then
  git clone --depth 1 -b "$BRANCH" "$PDFium_URL" pdfium
fi

# Reset
for FOLDER in pdfium pdfium/build pdfium/v8 pdfium/third_party/libjpeg_turbo pdfium/base/allocator/partition_allocator; do
  if [ -e "$FOLDER" ]; then
    git -C $FOLDER reset --hard
    git -C $FOLDER clean -df
  fi
done

# pdfium's DEPS has an unconditional cipd dep on infra/rbe/client/<platform>,
# which isn't published for linux-arm64 hosts — cipd ensure would abort.
# We never invoke remote execution during the build, so strip the entry
# before gclient resolves deps. gclient's custom_deps mechanism doesn't
# apply to cipd deps, so the patch must be against DEPS itself.
python3 <<'END'
import re, pathlib
p = pathlib.Path('pdfium/DEPS')
src = p.read_text()
new = re.sub(
    r"\n  'buildtools/reclient':\s*\{.*?\n  \},",
    "",
    src,
    count=1,
    flags=re.DOTALL,
)
if src == new:
    raise SystemExit("failed to strip reclient dep from DEPS")
p.write_text(new)
END

gclient sync -r "origin/$BRANCH" --no-history --shallow
