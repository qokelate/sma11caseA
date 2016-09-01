#!/bin/bash

SCRIPT_DIR="$(dirname $0)"
if [ '.' = "${SCRIPT_DIR:0:1}" ]; then
    SCRIPT_DIR="$(pwd)/${SCRIPT_DIR}"
fi
echo SCRIPT_DIR = ${SCRIPT_DIR}
cd "${SCRIPT_DIR}"

git add -A "iosFramework/*"
git add -A "iosFramework.xcodeproj/xcshareddata/*"

exit 0
