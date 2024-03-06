#!/usr/bin/env bash

declare RED="\e[0;31m"
declare CRESET="\e[0m"

print_and_run(){
	local command="$1"
	local time="$2"

	if [ "$command" = "" ]; then command=":"; fi
	if [ "$time" = "" ] ; then time="3s"; fi
	clear
	echo ">$command"
	sleep "$time"
	eval "$command"
	sleep "$time"
}

declare -a commands=( "ls" )
commands+=( "bash <(curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/nsainton/classcreator/main/classcreator.sh || echo exit 1) Test includes sources" )
commands+=( "ls" "ls includes sources" "bat includes/Test.h" "bat sources/Test.cpp" "c++ -c sources/Test.cpp -o Test.o -iquote includes" )
commands+=( "ls" )

for (( i=0 ; i<${#commands[@]}; ++i ))
	do if ! print_and_run "${commands[$i]}"; then echo -e "Error while running : ${RED}${commands[$i]}${CRESET}"; exit 1; fi
	done
