#!/bin/bash -eux

IS_DEBUG=${PDFium_IS_DEBUG:-false}
OS=${PDFium_TARGET_OS:?}
VERSION=${PDFium_VERSION:-}
PATCHES="$PWD/patches"
BUILD_TYPE=${PDFium_BUILD_TYPE:-shared}

SOURCE=${PDFium_SOURCE_DIR:-pdfium}
BUILD=${PDFium_BUILD_DIR:-pdfium/out}

STAGING="$PWD/staging"
STAGING_BIN="$STAGING/bin"
STAGING_LIB="$STAGING/lib"

mkdir -p "$STAGING"
rm -rf "$STAGING"/*
mkdir -p "$STAGING_LIB"

case "$BUILD_TYPE" in
  shared)
    CMAKE_CONFIG_FILE="PDFiumConfig.cmake"
    ;;
  static)
    CMAKE_CONFIG_FILE="PDFiumStaticConfig.cmake"
    ;;
esac
sed "s/#VERSION#/${VERSION:-0.0.0.0}/" <"$PATCHES/$CMAKE_CONFIG_FILE" >"$STAGING/PDFiumConfig.cmake"

cp LICENSE "$STAGING"
cat >>"$STAGING/LICENSE" <<END

This package also includes third-party software. See the licenses/ directory for their respective licenses.
END

cp "$BUILD/args.gn" "$STAGING"
cp -R "$SOURCE/public" "$STAGING/include"
rm -f "$STAGING/include/DEPS"
rm -f "$STAGING/include/README"
rm -f "$STAGING/include/PRESUBMIT.py"

case "$OS-$BUILD_TYPE" in
  linux-shared)
    mv "$BUILD/libpdfium.so" "$STAGING_LIB"
    ;;

  linux-static|mac-static)
    mv "$BUILD/obj/libpdfium.a" "$STAGING_LIB"
    ;;

  mac-shared)
    mv "$BUILD/libpdfium.dylib" "$STAGING_LIB"
    ;;

  win-shared)
    mv "$BUILD/pdfium.dll.lib" "$STAGING_LIB"
    mkdir -p "$STAGING_BIN"
    mv "$BUILD/pdfium.dll" "$STAGING_BIN"
    [ "$IS_DEBUG" == "true" ] && mv "$BUILD/pdfium.dll.pdb" "$STAGING_BIN"
    ;;

  win-static)
    mv "$BUILD/obj/pdfium.lib" "$STAGING_LIB"
    ;;
esac

# Bundle Chromium's vendored libc++ (+ libc++abi) into the tarball for
# Linux glibc static builds. These match the exact C++ runtime ABI that
# PDFium's objects were compiled against, so consumers never have to
# worry about host libstdc++/libc++ compatibility. The archives use the
# std::__Cr::* namespace so they don't collide with any other C++
# runtime the consumer might also link.
#
# Neither target is in libpdfium.a's transitive deps, so ninja doesn't
# build them by default — invoke them explicitly, then reify the thin
# archives (which are just pointer lists) into standalone .a files.
#
# Licenses: libc++ and libc++abi are dual-licensed under Apache 2.0
# with LLVM Exceptions and MIT.
if [ "$OS" == "linux" ] && [ "$BUILD_TYPE" == "static" ]; then
  ninja -C "$BUILD" \
    obj/buildtools/third_party/libc++/libc++.a \
    obj/buildtools/third_party/libc++abi/libc++abi.a
  for PAIR in "libc++/libc++.a" "libc++abi/libc++abi.a"; do
    THIN="$BUILD/obj/buildtools/third_party/$PAIR"
    OUT="$STAGING_LIB/$(basename "$PAIR")"
    if [ -f "$THIN" ]; then
      ar -M <<END
CREATE $OUT
ADDLIB $THIN
SAVE
END
    fi
  done
fi

if [ -n "$VERSION" ]; then
  cat >"$STAGING/VERSION" <<END
MAJOR=$(echo "$VERSION" | cut -d. -f1)
MINOR=$(echo "$VERSION" | cut -d. -f2)
BUILD=$(echo "$VERSION" | cut -d. -f3)
PATCH=$(echo "$VERSION" | cut -d. -f4)
END
fi
