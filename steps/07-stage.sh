#!/bin/bash -eux

IS_DEBUG=${PDFium_IS_DEBUG:-false}
OS=${PDFium_TARGET_OS:?}
TARGET_CPU=${PDFium_TARGET_CPU:?}
TARGET_ENVIRONMENT=${PDFium_TARGET_ENVIRONMENT:-}
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
  android-shared|linux-shared)
    mv "$BUILD/libpdfium.so" "$STAGING_LIB"
    ;;

  android-static|linux-static|mac-static|ios-static)
    mv "$BUILD/obj/libpdfium.a" "$STAGING_LIB"
    ;;

  mac-shared|ios-shared)
    mv "$BUILD/libpdfium.dylib" "$STAGING_LIB"
    ;;

  emscripten-*)
    mv "$BUILD/pdfium.html" "$STAGING_LIB"
    mv "$BUILD/pdfium.js" "$STAGING_LIB"
    mv "$BUILD/pdfium.wasm" "$STAGING_LIB"
    rm -rf "$STAGING/include/cpp"
    rm "$STAGING/PDFiumConfig.cmake"
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

# Bundle libstdc++.a into the tarball for Linux glibc static builds so
# consumers don't need libstdc++-XX-dev installed. The C++ runtime is
# GPL-3 with the GCC Runtime Library Exception, which permits inclusion
# in redistributable binaries.
if [ "$OS" == "linux" ] && [ "$BUILD_TYPE" == "static" ] && [ "$TARGET_ENVIRONMENT" != "musl" ]; then
  case "$TARGET_CPU" in
    arm)   STDCXX_GCC="arm-linux-gnueabihf-gcc-10" ;;
    arm64) STDCXX_GCC="aarch64-linux-gnu-gcc-10" ;;
    ppc64) STDCXX_GCC="powerpc64le-linux-gnu-gcc" ;;
    *)     STDCXX_GCC="gcc" ;;
  esac
  if command -v "$STDCXX_GCC" >/dev/null; then
    STDCXX_A=$("$STDCXX_GCC" --print-file-name=libstdc++.a 2>/dev/null || true)
    if [ -n "$STDCXX_A" ] && [ -f "$STDCXX_A" ]; then
      cp "$STDCXX_A" "$STAGING_LIB/"
    fi
  fi
fi

if [ -n "$VERSION" ]; then
  cat >"$STAGING/VERSION" <<END
MAJOR=$(echo "$VERSION" | cut -d. -f1)
MINOR=$(echo "$VERSION" | cut -d. -f2)
BUILD=$(echo "$VERSION" | cut -d. -f3)
PATCH=$(echo "$VERSION" | cut -d. -f4)
END
fi
