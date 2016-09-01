#!/bin/bash

SCRIPT_DIR="$(dirname $0)"
if [ '.' = "${SCRIPT_DIR:0:1}" ]; then
    SCRIPT_DIR="$(pwd)/${SCRIPT_DIR}"
fi
echo SCRIPT_DIR = ${SCRIPT_DIR}
cd "${SCRIPT_DIR}"

BUILD_PROJECT_ROOT="${SCRIPT_DIR}"
BUILD_PROJECT="${BUILD_PROJECT_ROOT}/sma11case.xcodeproj"

BUILD_OUTPUT_DIR="${SCRIPT_DIR}/build"
BUILD_OSX_DIR="${BUILD_OUTPUT_DIR}/osx"
BUILD_SIM_DIR="${BUILD_OUTPUT_DIR}/sim"
BUILD_ARM_DIR="${BUILD_OUTPUT_DIR}/arm"
BUILD_IOS_DIR="${BUILD_OUTPUT_DIR}/ios"

cd /tmp

rm -rf "${BUILD_OUTPUT_DIR}"

# 编译OSX架构二进制文件
xcodebuild -project "${BUILD_PROJECT}" -target "osxLibrary" ONLY_ACTIVE_ARCH=NO ARCHS="x86_64" VALID_ARCHS="i386 x86_64" -configuration "Release" -sdk "macosx" BUILD_DIR="${BUILD_OSX_DIR}" BUILD_ROOT="${BUILD_PROJECT_ROOT}" OBJROOT="${BUILD_OSX_DIR}" SYMROOT="${BUILD_OSX_DIR}"

# 编译ARM架构二进制文件
xcodebuild -project "${BUILD_PROJECT}" -target "iosLibrary" ONLY_ACTIVE_ARCH=NO ARCHS="armv7 armv7s arm64" VALID_ARCHS="armv7 armv7s arm64" -configuration "Release" -sdk "iphoneos"  BUILD_DIR="${BUILD_ARM_DIR}" BUILD_ROOT="${BUILD_PROJECT_ROOT}" OBJROOT="${BUILD_ARM_DIR}" SYMROOT="${BUILD_ARM_DIR}"

# 编译生成i386二进制文件
xcodebuild -project "${BUILD_PROJECT}" -target "iosLibrary" ONLY_ACTIVE_ARCH=NO ARCHS="i386 x86_64" VALID_ARCHS="i386 x86_64" -configuration "Release" -sdk "iphonesimulator"  BUILD_DIR="${BUILD_SIM_DIR}" BUILD_ROOT="${BUILD_PROJECT_ROOT}" OBJROOT="${BUILD_SIM_DIR}" SYMROOT="${BUILD_SIM_DIR}"

mkdir -pv "${BUILD_IOS_DIR}"
lipo -create -output "${BUILD_IOS_DIR}/libsma11caseSDK.a" "${BUILD_ARM_DIR}/Release-iphoneos/libiosLibrary.a" "${BUILD_SIM_DIR}/Release-iphonesimulator/libiosLibrary.a"

cd "${SCRIPT_DIR}"
echo copy resources "${SCRIPT_DIR}"

find "./Common" -type f -name '*.h' -print | xargs -I{} ./copyFile.sh "${SCRIPT_DIR}/{}" "${BUILD_IOS_DIR}/{}"
find "./IOS/iosLibrary" -type f -name '*.h' -print | xargs -I{} ./copyFile.sh "${SCRIPT_DIR}/{}" "${BUILD_IOS_DIR}/{}"
find "./IOS/iosLibrary" -type f -name '*.a' -print | xargs -I{} cp "${SCRIPT_DIR}/{}" "${BUILD_IOS_DIR}/"

find "./Common" -type f -name '*.h' -print | xargs -I{} ./copyFile.sh "${SCRIPT_DIR}/{}" "${BUILD_OSX_DIR}/{}"
find "./OSX/osxLibrary" -type f -name '*.h' -print | xargs -I{} ./copyFile.sh "${SCRIPT_DIR}/{}" "${BUILD_OSX_DIR}/{}"
find "./OSX/osxLibrary" -type f -name '*.a' -print | xargs -I{} cp "${SCRIPT_DIR}/{}" "${BUILD_OSX_DIR}/"
mv "${BUILD_OSX_DIR}/Release/libosxLibrary.a" "${BUILD_OSX_DIR}/libsma11caseSDK.a"
rm -rf "${BUILD_OSX_DIR}/Release"
rm -rf "${BUILD_OSX_DIR}/sma11case.build"

lipo -info "${BUILD_IOS_DIR}/libsma11caseSDK.a"
lipo -info "${BUILD_OSX_DIR}/libsma11caseSDK.a"

exit 0

