#!/usr/bin/env bash

declare RED="\e[0;31m"
declare CRESET="\e[0m"

print_and_run(){
	local command="$1"
	local description="$2"
	local time="$3"

	if [ "$command" = "" ]; then command=":"; fi
	if [ "$time" = "" ] ; then time="5s"; fi
	if [ "$description" = "" ]; then description="" ; fi
	clear
	echo -n ">$command"
	if [ "$description" != "" ] ; then echo " -> $description"; else echo"" ; fi
	sleep "$time"
	eval "$command"
	sleep "$time"
}

run_commands_file(){
	declare	command
	declare description
	declare commands_file="$1"
	declare descriptions_file="$2"

	if [ "$1" == "" ] ; then echo "Please provide at least a commands file "; exit 1; fi
	paste "$commands_file" "$descriptions_file" | while read -r command description
		do print_and_run "$command" "$description";
	done
}

main(){
	declare commands="$1"
	declare	descriptions="$2"

	if [ "$1" == "" ] ; then echo "Please provide a commands file"; exit 1; fi
}

declare -a commands=( "ls" )
commands+=( "bash <(curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/nsainton/classcreator/main/classcreator.sh || echo exit 1) Test includes sources" )
commands+=( "ls" "ls includes sources" "bat includes/Test.h" "bat sources/Test.cpp" "c++ -c sources/Test.cpp -o Test.o -iquote includes" )
commands+=( "ls" )

for (( i=0 ; i<${#commands[@]}; ++i ))
	do if ! print_and_run "${commands[$i]}"; then echo -e "Error while running : ${RED}${commands[$i]}${CRESET}"; exit 1; fi
	done
