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
    # Static builds: link the example with PDFium's shipped clang+lld to
    # match the toolchain the archive was compiled against. For arm64
    # cross-compile, drive clang with --target and the pdfium sysroot.
    if [ "${PDFium_BUILD_TYPE:-shared}" == "static" ]; then
      PDFIUM_CLANG_DIR="$PWD/pdfium/third_party/llvm-build/Release+Asserts/bin"
      EXTRA_CFLAGS="-fuse-ld=lld"
      case "$CPU" in
        arm64)
          SYSROOT="$PWD/pdfium/build/linux/debian_bullseye_arm64-sysroot"
          EXTRA_CFLAGS="--target=aarch64-linux-gnu --sysroot=$SYSROOT $EXTRA_CFLAGS"
          ;;
        x64)
          CAN_RUN_ON_HOST=true
          ;;
      esac
      CMAKE_ARGS+=(
        -D CMAKE_C_COMPILER="$PDFIUM_CLANG_DIR/clang"
        -D CMAKE_CXX_COMPILER="$PDFIUM_CLANG_DIR/clang++"
        -D CMAKE_C_FLAGS="$EXTRA_CFLAGS"
        -D CMAKE_CXX_FLAGS="$EXTRA_CFLAGS"
        -D CMAKE_EXE_LINKER_FLAGS="$EXTRA_CFLAGS"
      )
    else
      case "$CPU" in
        arm64)
          PREFIX="aarch64-linux-gnu-"
          SUFFIX="-10"
          ;;
        x64)
          CAN_RUN_ON_HOST=true
          ;;
      esac
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
