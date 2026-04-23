#!/bin/bash -eux

OS=${PDFium_TARGET_OS:?}
SOURCE=${PDFium_SOURCE_DIR:-pdfium}
BUILD=${PDFium_BUILD_DIR:-$SOURCE/out}
TARGET_CPU=${PDFium_TARGET_CPU:?}
IS_DEBUG=${PDFium_IS_DEBUG:-false}
BUILD_TYPE=${PDFium_BUILD_TYPE:-shared}

mkdir -p "$BUILD"

(
  echo "is_debug = $IS_DEBUG"
  echo "pdf_is_standalone = true"
  echo "pdf_use_partition_alloc = false"
  echo "target_cpu = \"$TARGET_CPU\""
  echo "target_os = \"$OS\""
  echo "pdf_enable_v8 = false"
  echo "pdf_enable_xfa = false"
  echo "treat_warnings_as_errors = false"
  echo "is_component_build = false"

  if [ "$BUILD_TYPE" == "static" ]; then
    echo "pdf_is_complete_lib = true"
    # On Linux glibc, keep Chromium's vendored libc++ (std::__Cr::* namespace)
    # so the archive's C++ runtime ABI is pinned to the exact build toolchain;
    # libc++.a and libc++abi.a are bundled alongside libpdfium.a in the tarball.
    # On mac/win, use the platform's native C++ runtime (libc++ / MSVC CRT).
    if [ "$OS" != "linux" ]; then
      echo "use_custom_libcxx = false"
      echo "use_custom_libcxx_for_host = false"
    fi
  fi

  case "$OS" in
    linux|mac)
      echo "clang_use_chrome_plugins = false"
      ;;
  esac

) | sort > "$BUILD/args.gn"

# Generate Ninja files
pushd "$SOURCE"
gn gen "$BUILD"
popd
