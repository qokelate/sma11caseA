#!/bin/zsh

SCRIPT_DIR="$(dirname $0)"
if [ '.' = "${SCRIPT_DIR:0:1}" ]; then
    SCRIPT_DIR="$(pwd)/${SCRIPT_DIR}"
fi
echo SCRIPT_DIR = ${SCRIPT_DIR}
cd "${SCRIPT_DIR}"

BUILD_PROJECT_ROOT="${SCRIPT_DIR}"
BUILD_PROJECT="${BUILD_PROJECT_ROOT}/osxFramework.xcworkspace"

BUILD_OUTPUT_DIR="${SCRIPT_DIR}/build"
BUILD_FW_DIR="${BUILD_OUTPUT_DIR}/Release"

cd /tmp

rm -rf "${BUILD_OUTPUT_DIR}"

xcodebuild -workspace "${BUILD_PROJECT}" -scheme "osxFramework" ONLY_ACTIVE_ARCH=NO ARCHS="x86_64" VALID_ARCHS="i386 x86_64" -configuration "Release" -sdk "macosx" BUILD_DIR="${BUILD_OUTPUT_DIR}" BUILD_ROOT="${BUILD_PROJECT_ROOT}" OBJROOT="${BUILD_OUTPUT_DIR}" SYMROOT="${BUILD_OUTPUT_DIR}"

mv "${BUILD_FW_DIR}/osxFramework.framework" "${BUILD_OUTPUT_DIR}/"

cd "${BUILD_FW_DIR}"
cp *.h "${BUILD_OUTPUT_DIR}/osxFramework.framework/Versions/A/Headers/"

rm -rf "${BUILD_FW_DIR}"

ln -s "${BUILD_OUTPUT_DIR}/osxFramework.framework/Headers" "${BUILD_OUTPUT_DIR}/"

lipo -info "${BUILD_OUTPUT_DIR}/osxFramework.framework/osxFramework"

exit 0
