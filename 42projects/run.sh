#!/usr/bin/bash

if declare -f "$1" > /dev/null
then
	"$@"
else
	echo "'$1' is not a function name" >&2
	exit 1
fi
