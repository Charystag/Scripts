#!/usr/bin/env bash

declare RED="\e[0;31m"
declare CRESET="\e[0m"

declare -a commands
declare -a description

#commands+=( "ls" )
#commands+=( "bash <(curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/nsainton/classcreator/main/classcreator.sh || echo exit 1) Test includes sources" )
#commands+=( "ls" "ls includes sources" "bat includes/Test.h" "bat sources/Test.cpp" "c++ -c sources/Test.cpp -o Test.o -iquote includes" )
#commands+=( "ls" )


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
	if ! eval "$command" ; then return 1; fi
	sleep "$time"
}

run_commands_file(){
	declare	command
	declare description
	declare commands_file="$1"
	declare descriptions_file="$2"

	if [ "$1" == "" ] ; then echo "Please provide at least a commands file "; exit 1; fi
	paste "$commands_file" "$descriptions_file" | while IFS=$'\t' read -r command description
		do if ! print_and_run "$command" "$description"; then echo -e "Error while running : ${RED}$command${CRESET}" ; exit 1; fi
	done
}

run_commands_arrays(){
	for (( i = 0; i<${#commands[@]}; ++i ))
	do if ! print_and_run "${commands[$i]}" "${descriptions[$i]}"; then echo -e "Error while running : ${RED}${commands[$i]}${CRESET}"; exit 1; fi
	done
}

help(){
	cat <<"HELP"
Please either fill the commands and descriptions array in the script
or run the script providing a commands_file and a descriptions_file
-You can run the script this way :
	./video.sh commands_file descriptions_file
HELP
}

main(){
	declare commands_file="$1"
	declare	descriptions_file="$2"

	if [ "$commands_file" != "" ] ; then run_commands_file "$commands_file" "$descriptions_file";  exit 0 ; fi
	if [ "${#commands[@]}" -gt "0" ] ; then run_commands_arrays; exit 0 ; fi
	help
	exit 1
}

main "$@"
