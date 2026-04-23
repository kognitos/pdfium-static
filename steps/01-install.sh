#!/bin/bash -eux

PATH_FILE=${GITHUB_PATH:-$PWD/.path}
TARGET_OS=${PDFium_TARGET_OS:?}
TARGET_CPU=${PDFium_TARGET_CPU:?}
CURRENT_CPU=${PDFium_CURRENT_CPU:-x64}

DepotTools_URL='https://chromium.googlesource.com/chromium/tools/depot_tools.git'
DepotTools_DIR="$PWD/depot_tools"
WindowsSDK_DIR="/c/Program Files (x86)/Windows Kits/10/bin/10.0.19041.0"

# Download depot_tools if not exists in this location
if [ ! -d "$DepotTools_DIR" ]; then
  git clone "$DepotTools_URL" "$DepotTools_DIR"
fi

echo "$DepotTools_DIR" >> "$PATH_FILE"

case "$TARGET_OS" in
  linux)
    sudo apt-get update
    # lld is needed to link the static-build example test against PDFium's
    # clang-emitted .eh_frame sections (GNU ld rejects them).
    sudo apt-get install -y cmake pkg-config lld

    case "$TARGET_CPU" in
      arm64)
        sudo apt-get install -y libc6-i386 gcc-10-multilib g++-10-aarch64-linux-gnu gcc-10-aarch64-linux-gnu
        ;;

      x64)
        sudo apt-get install -y g++
        ;;
    esac
    ;;

  win)
    echo "$WindowsSDK_DIR/$CURRENT_CPU" >> "$PATH_FILE"
    ;;

  mac)
    sudo xcode-select -s "/Applications/Xcode_26.0.app"
    ;;
esac
