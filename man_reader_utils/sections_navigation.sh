#!/usr/bin/env bash

. man_splitting.sh
. ../utils/utils.sh

export SECTIONS_NAVIGATION=1

:<<-'SECTIONS_REFERENCES'
	This function takes the path to a man page as an input and
	outputs the other man-pages it references
	SECTIONS_REFERENCES
sections_references(){
	declare prompt="Please give a man_page to look for"
	declare page="$1"
	declare ret_val
	declare regexp

	if [ "$1" = "" ] ; then user_input "$prompt" page ; fi
	if [ "$1" = "" ] ; then exit 1 ; fi
	regexp='\\fB([[:alnum:]]|-)+\\f[[:alpha:]]{1}\([[:digit:]]{1}\)|([[:alnum:]]|[-\])+[ ]?\([[:digit:]]{1}\)'
	if ! find_page_section "$page" ; then return 1 ; fi
	add_slash ret_val b
	zcat "$ret_val" | grep -E -o "$regexp"
}

sections_references "$@"
