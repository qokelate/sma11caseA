#!/bin/zsh

if [ -f "$1" ]; then
	if [ ! "" = "$2" ]; then
		arg2=$2
		dir2="${arg2%/*}"
		mkdir -pv "$dir2"
		cp "$1" "$dir2/"
	fi
fi

exit 0
