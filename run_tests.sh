#!/usr/bin/env sh
# shellcheck disable=SC3043

get_executable_name(){
	local makefile

	if [ "$1" = "" ] ; then return 1; fi;
	makefile="$(mktemp)"
	cat <<MAKEFILE >"$makefile"
include Makefile
\$(info \${$1})
MAKEFILE
	make -q -f "$makefile"
	rm "$makefile"
}

run_tests(){
	local name

	name="$(get_executable_name NAME)"
	make || { clear ; echo "Error running make" ; return 1 ; }
	if [ "$debug" = "1" ] ; then echo "This is the test_command : $test_command" ; fi
	eval "$test_command" ./"$name" "$*"
}

parse_options(){
	local optstring
	local option

	optstring="t:o:d"
	while getopts "$optstring" option ; do
	case "$option" in
		o)
			test_command="$test_command $OPTARG" ;;
		t)
			echo "$OPTARG"
			test_command="$OPTARG" ;;
		d)
			debug=1 ;;
		?)
			echo "usage: ./run_tests [-t test_command] [-o option] [-d] args" ; kill -INT $$ ;;
	esac
	done
}

main(){
	local test_command
	local debug

	test_command="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"
	debug=0
	parse_options "$@"
	shift $((OPTIND - 1))
	run_tests "$@"
}

main "$@"
