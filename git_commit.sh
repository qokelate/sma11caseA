#!/bin/bash

SCRIPT_DIR="$(dirname $0)"
if [ '.' = "${SCRIPT_DIR:0:1}" ]; then
    SCRIPT_DIR="$(pwd)/${SCRIPT_DIR}"
fi
echo SCRIPT_DIR = ${SCRIPT_DIR}
cd "${SCRIPT_DIR}"

git add -A Common/*
git add -A ETC/*
git add -A IOS/iosLibrary/*
git add -A IOS/iosClient/*
git add -A OSX/osxLibrary/*
git add -A OSX/osxClient/*
git add -A OSX/osxCMD/*
git add -A sma11case.xcodeproj/xcshareddata/*

"./Demo/git_commit.sh"
"./IOS/iosComponents/git_commit.sh"
"./OSX/osxComponents/git_commit.sh"

COMMIT_MESSAGE='sma11caseSDK v2.0'
if [ -n "$1" ]; then
	COMMIT_MESSAGE=$1
fi
git commit -am "${COMMIT_MESSAGE}"

git branch | grep '* master' >/dev/null 2>/dev/null && git push origin master

exit 0
