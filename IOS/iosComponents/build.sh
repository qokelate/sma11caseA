#!/bin/zsh

SCRIPT_DIR="$(dirname $0)"
if [ '.' = "${SCRIPT_DIR:0:1}" ]; then
    SCRIPT_DIR="$(pwd)/${SCRIPT_DIR}"
fi
echo SCRIPT_DIR = ${SCRIPT_DIR}
cd "${SCRIPT_DIR}"

BUILD_PROJECT_ROOT="${SCRIPT_DIR}"
BUILD_PROJECT="${BUILD_PROJECT_ROOT}/iosFramework.xcworkspace"

BUILD_OUTPUT_DIR="${SCRIPT_DIR}/build"
BUILD_SIM_DIR="${BUILD_OUTPUT_DIR}/sim/Release-iphonesimulator"
BUILD_IOS_DIR="${BUILD_OUTPUT_DIR}/ios/Release-iphoneos"

cd /tmp

rm -rf "${BUILD_OUTPUT_DIR}"

xcodebuild -workspace "${BUILD_PROJECT}" -scheme "iosFramework" ONLY_ACTIVE_ARCH=NO ARCHS="i386 x86_64" VALID_ARCHS="i386 x86_64" -configuration "Release" -sdk "iphonesimulator"  BUILD_DIR="${BUILD_OUTPUT_DIR}/sim" BUILD_ROOT="${BUILD_PROJECT_ROOT}" OBJROOT="${BUILD_OUTPUT_DIR}/sim" SYMROOT="${BUILD_OUTPUT_DIR}/sim"

xcodebuild -workspace "${BUILD_PROJECT}" -scheme "iosFramework" ONLY_ACTIVE_ARCH=NO ARCHS="armv7 armv7s arm64" VALID_ARCHS="armv7 armv7s arm64" -configuration "Release" -sdk "iphoneos"  BUILD_DIR="${BUILD_OUTPUT_DIR}/ios" BUILD_ROOT="${BUILD_PROJECT_ROOT}" OBJROOT="${BUILD_OUTPUT_DIR}/ios" SYMROOT="${BUILD_OUTPUT_DIR}/ios"

mv "${BUILD_IOS_DIR}/iosFramework.framework" "${BUILD_OUTPUT_DIR}/"
mv "${BUILD_OUTPUT_DIR}/iosFramework.framework/iosFramework" "${BUILD_OUTPUT_DIR}/iosFramework.framework/iosFramework.ios"

lipo -create -output "${BUILD_OUTPUT_DIR}/iosFramework.framework/iosFramework" "${BUILD_SIM_DIR}/iosFramework.framework/iosFramework" "${BUILD_OUTPUT_DIR}/iosFramework.framework/iosFramework.ios"

cd "${BUILD_IOS_DIR}"
cp *.h "${BUILD_OUTPUT_DIR}/iosFramework.framework/Headers/"

rm -f "${BUILD_OUTPUT_DIR}/iosFramework.framework/iosFramework.ios"
rm -rf "${SCRIPT_DIR}/build/sim"
rm -rf "${SCRIPT_DIR}/build/ios"

ln -s "${BUILD_OUTPUT_DIR}/iosFramework.framework/Headers" "${BUILD_OUTPUT_DIR}/"

lipo -info "${BUILD_OUTPUT_DIR}/iosFramework.framework/iosFramework"

exit 0
