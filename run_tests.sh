#!/usr/bin/env sh

get_executable_name(){
	local makefile

	if [ "$1" = "" ] ; then return 1; fi;
	makefile="$(mktemp)"
	cat <<MAKEFILE >"$(makefile)"
#include Makefile
\$(info \${$1})
MAKEFILE
	make -q -f "$makefile"
	rm "$makefile"
}

run_tests(){
	local name
	local test_command

	name="$(get_executable_name NAME)"
	if [ "$1" != "" ] ; then test_command="$1" ; shift; fi
	make || { clear ; echo "Error running make" ; return 1 ; }
	eval "$test_command" ./"$name" "$@"
}

main(){
	run_tests "$@"
}

main "$@"
