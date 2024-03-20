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

	name="$(get_executable_name NAME)"
	if [ "$1" != "" ] ; then test_command="$1" ; shift; fi
	make || { clear ; echo "Error running make" ; return 1 ; }
	eval "$test_command" ./"$name" "$@"
}

parse_options(){
	local optstring
	local option

	optstring="t:s:"
	while getops "$optrstring" option ; do
	case "$option" in
		s)
			test_command="$test_command $OPTARG" ;;
		t)
			test_command="$OPTARG" ;;
	esac
	done
}

main(){
	local test_command

	test_command="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --trace-fds=all"
	parse_options
	shift $(($OPTIND - 1))
	run_tests "$@"
}

main "$@"
