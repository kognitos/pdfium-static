# Pre-compiled static binaries of PDFium

[![Latest release](https://img.shields.io/github/v/release/kognitos/pdfium-static?display_name=release&label=github)](https://github.com/kognitos/pdfium-static/releases/latest/)
[![Total downloads](https://img.shields.io/github/downloads/kognitos/pdfium-static/total)](https://github.com/kognitos/pdfium-static/releases/)

This project hosts pre-compiled **static** binaries of the [PDFium library](https://pdfium.googlesource.com/pdfium/), an open-source library for PDF manipulation and rendering.

It is a fork of [bblanchon/pdfium-binaries](https://github.com/bblanchon/pdfium-binaries/), specialized to produce static archives (`.a` on Linux/macOS/iOS/Android, `.lib` on Windows) so that PDFium can be linked directly into an application without shipping a separate shared library.

**Disclaimer**: This project isn't affiliated with Google or Foxit.

## Download

Here are the download links for latest release:

<table>
  <tr>
    <th>OS</th>
    <th>Env</th>
    <th>CPU</th>
    <th>PDFium (static)</th>
  </tr>

  <tr>
    <td rowspan="4" colspan=2>Android</td>
    <td>arm</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-android-arm-static.tgz">pdfium-android-arm-static.tgz</a></td>
  </tr>
  <tr>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-android-arm64-static.tgz">pdfium-android-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-android-x64-static.tgz">pdfium-android-x64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x86</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-android-x86-static.tgz">pdfium-android-x86-static.tgz</a></td>
  </tr>

  <tr>
    <td rowspan="5">iOS</td>
    <td rowspan="2">catalyst</td>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-ios-catalyst-arm64-static.tgz">pdfium-ios-catalyst-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-ios-catalyst-x64-static.tgz">pdfium-ios-catalyst-x64-static.tgz</a></td>
  </tr>
  <tr>
    <td>device</td>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-ios-device-arm64-static.tgz">pdfium-ios-device-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td rowspan="2">simulator</td>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-ios-simulator-arm64-static.tgz">pdfium-ios-simulator-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-ios-simulator-x64-static.tgz">pdfium-ios-simulator-x64-static.tgz</a></td>
  </tr>

  <tr>
    <td rowspan="8">Linux</td>
    <td rowspan="5">glibc</td>
    <td>arm</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-arm-static.tgz">pdfium-linux-arm-static.tgz</a></td>
  </tr>
  <tr>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-arm64-static.tgz">pdfium-linux-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td>ppc64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-ppc64-static.tgz">pdfium-linux-ppc64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-x64-static.tgz">pdfium-linux-x64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x86</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-x86-static.tgz">pdfium-linux-x86-static.tgz</a></td>
  </tr>
  <tr>
    <td rowspan="3">musl</td>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-musl-arm64-static.tgz">pdfium-linux-musl-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-musl-x64-static.tgz">pdfium-linux-musl-x64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x86</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-linux-musl-x86-static.tgz">pdfium-linux-musl-x86-static.tgz</a></td>
  </tr>

  <tr>
    <td rowspan="2" colspan="2">macOS</td>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-mac-arm64-static.tgz">pdfium-mac-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-mac-x64-static.tgz">pdfium-mac-x64-static.tgz</a></td>
  </tr>

  <tr>
    <td rowspan="3" colspan="2">Windows</td>
    <td>arm64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-win-arm64-static.tgz">pdfium-win-arm64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x64</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-win-x64-static.tgz">pdfium-win-x64-static.tgz</a></td>
  </tr>
  <tr>
    <td>x86</td>
    <td><a href="https://github.com/kognitos/pdfium-static/releases/latest/download/pdfium-win-x86-static.tgz">pdfium-win-x86-static.tgz</a></td>
  </tr>
</table>

See the [Releases page](https://github.com/kognitos/pdfium-static/releases) to download older versions of PDFium.

If you need a **shared-library** build (`.so` / `.dll` / `.dylib`), NuGet packages, Conda packages, V8-enabled builds, or WebAssembly, use the upstream project: [bblanchon/pdfium-binaries](https://github.com/bblanchon/pdfium-binaries/).

## Documentation

### PDFium API documentation

The PDFium API is documented at [developers.foxit.com](https://developers.foxit.com/resources/pdf-sdk/c_api_reference_pdfium/index.html).

### How to use PDFium in a CMake project

1. Unzip the downloaded package in a folder (e.g., `C:\Libraries\pdfium`)
2. Set the environment variable `PDFium_DIR` to this folder (e.g., `C:\Libraries\pdfium`)
3. In your `CMakeLists.txt`, add

        find_package(PDFium)

4. Then link your executable with PDFium:

        target_link_libraries(my_exe pdfium)

The `pdfium` CMake target propagates everything consumers need:

- the include directory,
- the system libraries the static archive depends on:
  - Linux: `pthread`, `dl`, `m`
  - macOS: `CoreGraphics`, `CoreFoundation`, `CoreText`, `AppKit` frameworks
  - Windows: `gdi32`, `user32`, `advapi32`, `comdlg32`, `shell32`
- the `FPDF_STATIC` compile definition (required on Windows so that `FPDF_EXPORT` resolves to an empty macro rather than `__declspec(dllimport)`). You do **not** need to define `FPDF_STATIC` yourself as long as you link via `find_package(PDFium)`.

### Using PDFium without CMake

If you can't use `find_package`, on Windows you must define `FPDF_STATIC` for every translation unit that includes PDFium headers (otherwise the compiler will emit `__declspec(dllimport)` on every `FPDF_*` function, leading to unresolved `__imp_*` symbols at link time). On Linux/macOS/iOS/Android, no extra define is needed.

### Bundled libc++ (Linux glibc tarballs)

For Linux glibc targets, Chromium's vendored C++ runtime (`libc++.a`, `libc++abi.a`, `libunwind.a`) is bundled alongside `libpdfium.a`. This is the exact toolchain PDFium was compiled against, so consumers never have to worry about the host's `libstdc++` or `libc++` version matching. `find_package(PDFium)` links the bundled archives automatically.

The bundled libc++ build uses Chromium's [inline namespace mangling](https://libcxx.llvm.org/DesignDocs/ABIVersioning.html) (`std::__Cr::*`), so it does not collide with any other C++ runtime your program may also link (system `libstdc++`, a second `libc++`, etc.). Consumer code written against `std::` types works with the consumer's own C++ runtime; PDFium's internal `std::__Cr::*` references are satisfied by the bundled archives only.

`libc++` and `libc++abi` are dual-licensed under Apache 2.0 with LLVM Exceptions and MIT; `libunwind` under Apache 2.0. Redistribution and static linking into non-GPL consumer code are explicitly permitted.

## Relationship to upstream

This fork tracks [bblanchon/pdfium-binaries](https://github.com/bblanchon/pdfium-binaries/) and follows the same weekly build cadence against upstream PDFium's `chromium/*` branches. The only meaningful divergences are:

- CI produces static archives instead of shared libraries.
- Release tarballs are suffixed with `-static`.
- V8, NuGet, Conda, macOS universal, and WebAssembly targets are not built (use upstream for those).
- A minor patch to `public/fpdfview.h` guards the Windows dllimport/dllexport block with `FPDF_STATIC` so the same headers work for static consumers.

## Related projects

The following projects use (or recommend using) PDFium builds from the upstream project — several of them work just as well with the static tarballs published here:

| Name                           | Language | Description                                                                             |
| :----------------------------- | :------- | :-------------------------------------------------------------------------------------- |
| [dart_pdf][dart_pdf]           | Dart     | PDF creation module for dart/flutter                                                    |
| [DtronixPdf][dtronixpdf]       | C#       | PDF viewer and editor toolset                                                           |
| [go-pdfium][go-pdfium]         | Go       | Go wrapper around PDFium with image rendering and text extraction                       |
| [libvips][libvips]             | C        | A performant image processing library                                                   |
| [PDFium RS][pdfium_rs]         | Rust     | Rust wrapper around PDFium                                                              |
| [pdfium-render][pdfium-render] | Rust     | A high-level idiomatic Rust wrapper around PDFium                                       |
| [pdfium-vfp][pdfium-vfp]       | VFP      | PDF Viewer component for Visual FoxPro                                                  |
| [pdfium.vapi][pdfium-vapi]     | Vala     | Vala vapi binding and GTK demo app to display PDF content                               |
| [PDFiumCore][pdfiumcore]       | C#       | .NET Standard P/Invoke bindings for PDFium                                              |
| [PdfiumLib][pdfiumlib]         | Pascal   | An interface to libpdfium for Delphi                                                    |
| [PdfLibCore][pdflibcore]       | C#       | A fast PDF editing and reading library for modern .NET Core applications                |
| [PDFtoImage][pdftoimage]       | C#       | .NET library to render PDF content into images                                          |
| [PDFtoZPL][pdftozpl]           | C#       | A .NET library to convert PDF files (and bitmaps) into Zebra Programming Language code  |
| [PDFx][pdfx]                   | Dart     | Flutter Render & show PDF documents on Web, MacOs 10.11+, Android 5.0+, iOS and Windows |
| [PyPDFium2][pypdfium2]         | Python   | Python bindings to PDFium                                                               |
| [Spacedrive][spacedrive]       | Rust/TS  | Cross-platform file manager, powered by a virtual distributed filesystem                |
| [wxPDFView][wxpdfview]         | C++      | wxWidgets components to display PDF content                                             |

## Credits

The build infrastructure here is the work of [@bblanchon](https://github.com/bblanchon) and the upstream [pdfium-binaries contributors](https://github.com/bblanchon/pdfium-binaries/graphs/contributors). This fork only adapts it for static-library output. Please file upstream issues and PRs at [bblanchon/pdfium-binaries](https://github.com/bblanchon/pdfium-binaries/) unless they are specific to the static build path.

[dart_pdf]: https://github.com/DavBfr/dart_pdf
[dtronixpdf]: https://github.com/Dtronix/DtronixPdf
[go-pdfium]: https://github.com/klippa-app/go-pdfium
[libvips]: https://github.com/libvips/libvips
[pdfium_rs]: https://github.com/asafigan/pdfium_rs
[pdfium-render]: https://github.com/ajrcarey/pdfium-render
[pdfium-vapi]: https://github.com/taozuhong/pdfium.vapi
[pdfium-vfp]: https://github.com/dmitriychunikhin/pdfium-vfp
[pdfiumcore]: https://github.com/Dtronix/PDFiumCore
[pdfiumlib]: https://github.com/ahausladen/PdfiumLib
[pdflibcore]: https://github.com/jbaarssen/PdfLibCore
[pdftoimage]: https://github.com/sungaila/PDFtoImage
[pdftozpl]: https://github.com/sungaila/PDFtoZPL
[pdfx]: https://github.com/scerio/packages.flutter/tree/main/packages/pdfx
[pypdfium2]: https://github.com/pypdfium2-team/pypdfium2
[spacedrive]: https://github.com/spacedriveapp/spacedrive
[wxpdfview]: https://github.com/TcT2k/wxPDFView
