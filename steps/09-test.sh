#!/bin/bash -eux

OS=${PDFium_TARGET_OS:?}
CPU="${PDFium_TARGET_CPU:?}"
SOURCE_DIR="$PWD/example"
CMAKE_ARGS=()
CAN_RUN_ON_HOST=false
EXAMPLE="./example"

export PDFium_DIR="$PWD/staging"

case "$OS" in
  linux)
    case "$CPU" in
      arm64)
        if [ "$(uname -m)" == "aarch64" ]; then
          CAN_RUN_ON_HOST=true
        else
          PREFIX="aarch64-linux-gnu-"
          SUFFIX="-10"
        fi
        ;;
      x64)
        CAN_RUN_ON_HOST=true
        ;;
    esac
    # For static glibc builds, compile the example with PDFium's shipped
    # clang+lld. The static archive is built against the Debian bullseye
    # sysroot's libstdc++; mixing it with the host gcc's noble libstdc++
    # yields ABI-level template instantiations that crash at runtime.
    if [ "${PDFium_BUILD_TYPE:-shared}" == "static" ] && [ -z "${PREFIX:-}" ]; then
      PDFIUM_CLANG_DIR="$PWD/pdfium/third_party/llvm-build/Release+Asserts/bin"
      CMAKE_ARGS+=(
        -D CMAKE_C_COMPILER="$PDFIUM_CLANG_DIR/clang"
        -D CMAKE_CXX_COMPILER="$PDFIUM_CLANG_DIR/clang++"
        -D CMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"
      )
    else
      CMAKE_ARGS+=(
        -D CMAKE_C_COMPILER="${PREFIX:-}gcc${SUFFIX:-}"
        -D CMAKE_CXX_COMPILER="${PREFIX:-}g++${SUFFIX:-}"
      )
    fi
    ;;

  mac)
    case "$CPU" in
      arm64)
        ARCH="arm64"
        ;;
      x64)
        ARCH="x86_64"
        CAN_RUN_ON_HOST=true
        ;;
    esac
    CMAKE_ARGS+=(
      -D CMAKE_OSX_ARCHITECTURES="$ARCH"
    )
    ;;

  win)
    case "$CPU" in
      arm64)
        ARCH="ARM64"
        ;;
      x64)
        ARCH="x64"
        CAN_RUN_ON_HOST=true
        ;;
    esac
    CMAKE_ARGS+=(
      -G "Visual Studio 17 2022"
      -A "$ARCH"
    )
    EXAMPLE="Debug/example.exe"
    ;;
esac

CMAKE_ARGS+=("$SOURCE_DIR")

mkdir -p build
pushd build
rm -rf *

cmake "${CMAKE_ARGS[@]}"
cmake --build .

file $EXAMPLE

if [ $CAN_RUN_ON_HOST == "true" ]; then
  $EXAMPLE "${PDFium_SOURCE_DIR}/testing/resources/hello_world.pdf" hello_world.ppm
fi

popd
