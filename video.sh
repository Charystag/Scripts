#!/usr/bin/env bash

declare RED="\e[0;31m"
declare CRESET="\e[0m"

declare -a commands
declare -a descriptions

#commands+=( "ls" )
#commands+=( "bash <(curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/nsainton/classcreator/main/classcreator.sh || echo exit 1) Test includes sources" )
#commands+=( "ls" "ls includes sources" "bat includes/Test.h" "bat sources/Test.cpp" "c++ -c sources/Test.cpp -o Test.o -iquote includes" )
#commands+=( "ls" )


print_command(){
	local command="$1"
	local description="$2"
	local time="$3"

	echo -n ">$command"
	if [ "$description" != "" ] ; then echo " <-> $description"; else echo ""; fi
	sleep "$time"
}

print_and_run(){
	local command="$1"
	local description="$2"
	local time="$3"

	if [ "$command" = "" ]; then command=":"; fi
	if [ "$time" = "" ] ; then time="5s"; fi
	if [ "$description" = "" ]; then description="" ; fi
	clear
	if [ "${command:0:1}" != "@" ] ; then print_command "$command" "$description" "$time"
	else command="${command:1}" ; fi
	if ! eval "$command" ; then return 1; fi
	sleep "$time"
}

run_commands_files(){
	declare	command
	declare description
	declare commands_file="$1"
	declare descriptions_file="$2"

	if [ "$commands_file" == "" ] ; then echo "Please provide at least a commands file "; exit 1; fi
	paste "$commands_file" "$descriptions_file" | while IFS=$'\t' read -r command description
		do if ! print_and_run "$command" "$description"; then echo -e "Error while running : ${RED}$command${CRESET}" ; exit 1; fi
	done
}

run_commands_file(){
	declare	command
	declare description
	declare	commands_file="$1"

	echo "Here"
	if [ "$commands_file" == "" ] ; then echo "Please provide at least a commands file "; exit 1; fi
	while IFS="|" read -r command description
	do
		if ! print_and_run "$command" "$description"; then echo -e "Error while running : ${RED}$command${CRESET}" ; exit 1; fi
	done < "$commands_file"

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
You can specify commands that won't be printed (nor their descriptions)
by prefixing the line with a '@'
-You can run the script this way :
	./video.sh commands_file descriptions_file
	./video.sh commands_file (with commands and descriptions separated by a '|' symbol)
	./video.sh
HELP
}

main(){
	declare commands_file="$1"
	declare	descriptions_file="$2"

	if [ "$commands_file" != "" ] && [ "$descriptions_file" != "" ] ; then run_commands_files "$commands_file" "$descriptions_file";  exit 0 ; fi
	if [ "$commands_file" != "" ] ; then run_commands_file "$commands_file"; exit 0; fi
	if [ "${#commands[@]}" -gt "0" ] ; then run_commands_arrays; exit 0 ; fi
	help
	exit 1
}

main "$@"
