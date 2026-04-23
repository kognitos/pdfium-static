# PDFium Package Configuration for CMake (static build)
#
# To use PDFium in your CMake project:
#
#   1. set the environment variable PDFium_DIR to the folder containing this file.
#   2. in your CMakeLists.txt, add
#       find_package(PDFium)
#   3. then link your executable with PDFium
#       target_link_libraries(my_exe pdfium)

include(FindPackageHandleStandardArgs)

find_path(PDFium_INCLUDE_DIR
    NAMES "fpdfview.h"
    PATHS "${CMAKE_CURRENT_LIST_DIR}"
    PATH_SUFFIXES "include"
)

set(PDFium_VERSION "#VERSION#")

if(WIN32)
  find_file(PDFium_LIBRARY
        NAMES "pdfium.lib"
        PATHS "${CMAKE_CURRENT_LIST_DIR}"
        PATH_SUFFIXES "lib")
  # MSVC auto-links the C/C++ runtime; no explicit stdlib entry needed.
  set(PDFium_SYSTEM_LIBS gdi32 user32 advapi32 comdlg32 shell32)
elseif(APPLE)
  find_library(PDFium_LIBRARY
        NAMES "pdfium"
        PATHS "${CMAKE_CURRENT_LIST_DIR}"
        PATH_SUFFIXES "lib")
  set(PDFium_SYSTEM_LIBS
    c++
    "-framework CoreGraphics"
    "-framework CoreFoundation"
    "-framework CoreText"
    "-framework AppKit")
elseif(ANDROID)
  find_library(PDFium_LIBRARY
        NAMES "pdfium"
        PATHS "${CMAKE_CURRENT_LIST_DIR}"
        PATH_SUFFIXES "lib")
  # Android NDK provides libc++ as the default STL.
  set(PDFium_SYSTEM_LIBS c++ pthread dl m)
else()
  find_library(PDFium_LIBRARY
        NAMES "pdfium"
        PATHS "${CMAKE_CURRENT_LIST_DIR}"
        PATH_SUFFIXES "lib")
  # Glibc tarballs ship Chromium's vendored libc++ (std::__Cr::*) so the
  # archive's C++ runtime ABI is pinned to its build toolchain. Musl
  # tarballs don't ship these; fall back to the system libstdc++.
  find_file(PDFium_LIBCXX_LIBRARY
        NAMES "libc++.a"
        PATHS "${CMAKE_CURRENT_LIST_DIR}"
        PATH_SUFFIXES "lib"
        NO_DEFAULT_PATH)
  find_file(PDFium_LIBCXXABI_LIBRARY
        NAMES "libc++abi.a"
        PATHS "${CMAKE_CURRENT_LIST_DIR}"
        PATH_SUFFIXES "lib"
        NO_DEFAULT_PATH)
  find_file(PDFium_LIBUNWIND_LIBRARY
        NAMES "libunwind.a"
        PATHS "${CMAKE_CURRENT_LIST_DIR}"
        PATH_SUFFIXES "lib"
        NO_DEFAULT_PATH)
  if(PDFium_LIBCXX_LIBRARY)
    set(PDFium_SYSTEM_LIBS "${PDFium_LIBCXX_LIBRARY}")
    if(PDFium_LIBCXXABI_LIBRARY)
      list(APPEND PDFium_SYSTEM_LIBS "${PDFium_LIBCXXABI_LIBRARY}")
    endif()
    if(PDFium_LIBUNWIND_LIBRARY)
      list(APPEND PDFium_SYSTEM_LIBS "${PDFium_LIBUNWIND_LIBRARY}")
    endif()
    list(APPEND PDFium_SYSTEM_LIBS pthread dl m)
  else()
    set(PDFium_SYSTEM_LIBS stdc++ pthread dl m)
  endif()
endif()

add_library(pdfium STATIC IMPORTED)
set_target_properties(pdfium
  PROPERTIES
  IMPORTED_LOCATION                 "${PDFium_LIBRARY}"
  IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
  INTERFACE_INCLUDE_DIRECTORIES     "${PDFium_INCLUDE_DIR};${PDFium_INCLUDE_DIR}/cpp"
  INTERFACE_COMPILE_DEFINITIONS     "FPDF_STATIC"
  INTERFACE_LINK_LIBRARIES          "${PDFium_SYSTEM_LIBS}"
)

find_package_handle_standard_args(PDFium
  REQUIRED_VARS PDFium_LIBRARY PDFium_INCLUDE_DIR
  VERSION_VAR PDFium_VERSION
)
