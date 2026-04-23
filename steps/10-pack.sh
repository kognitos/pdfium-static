#!/bin/bash -eux

IS_DEBUG=${PDFium_IS_DEBUG:-false}
OS=${PDFium_TARGET_OS:?}
CPU=${PDFium_TARGET_CPU:?}
BUILD_TYPE=${PDFium_BUILD_TYPE:-shared}
STAGING="$PWD/staging"

ARTIFACT_BASE="$PWD/pdfium-$OS-$CPU"
[ "$BUILD_TYPE" == "static" ] && ARTIFACT_BASE="$ARTIFACT_BASE-static"
[ "$IS_DEBUG" == "true" ] && ARTIFACT_BASE="$ARTIFACT_BASE-debug"
ARTIFACT="$ARTIFACT_BASE.tgz"

pushd "$STAGING"
tar cvzf "$ARTIFACT" -- *
popd
