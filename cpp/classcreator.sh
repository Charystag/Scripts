#!/usr/bin/env sh

usage(){
	local name

	name="$1"
	cat <<USAGE
Usage: $name classname [dir] [header_dir class_dir]
Examples:
	-$name classname -> creates a classname.cpp and classname.h class file in the current directory
	-$name classname dir -> creates a dir/classname.cpp and dir/classname.h 
	class file in the specified directory
	-$name classname header_dir class_dir -> creates a header_dir/classname.h and a 
	class_dir/classname.cpp file in the specified directories for header files and source files
USAGE
}

:<<-"GETNAME"
	Function that gets the name of the script that should be used for the printing messages
GETNAME
getname(){
	if echo "$0" | grep -E "^/proc/self/fd" 1>/dev/null;then name="classcreator"
	else name="$(basename -s .sh "$0")"; fi
}

:<<-CREATE_FILE
	Function that creates a file with the given filename as an input. If no file is provided, do nothing
	If the file can't be created, return an error
CREATE_FILE
create_file(){
	if [ "$1" = "" ] ; then return 1; fi
	if [ -f "$1" ] ; then shred -f -n 10 -u -z "$1"; fi
	if ! touch "$1" ; then echo "Couldn't create file : $1"; return 1;fi
	return 0;
}

:<<-"ADD_SLASH_DIR"
	Function that adds a trailing '/' if needed to a directory name
ADD_SLASH_DIR
add_slash_dir(){
	
}

:<<-"GETPATHS"
	Function that gets the paths to the class header file and to the class source
	According to the arguments that were provided to the script
GETPATHS
getpaths(){
	local dir

	if [ "$2" = "" ] ; then class_header="$1".h ; class_source="$1".cpp; return 0; fi
	dir="$2"
	add_slash_dir
	if [ "$3" = "" ] ; then class_header="$dir"
}


:<<-"CREATE_HEADER"
CREATE_HEADER
create_header(){
	local header
	local upp

	if [ "$1" = "" ] ; then return 1 ; fi
	class="$1"
	upp="$(echo "$class" | tr [:lower:] [:upper:])"
	if ! create_file "$header" ; then return 1 ; fi
	cat >"$header" <<HEADER
#ifndef __${upp}_H__
# define __${upp}_H__

class	$class{
	public:
		$class();
		$class( const $class & );
		$class& operator=( const $class & );
		virtual ~$class();
};
#endif
HEADER
	return 0
}

:<<-"CREATE_CLASS"
CREATE_CLASS
create_class(){
	local class
	local classfile

	if [ "$1" = "" ] ; then return 1 ; fi
	class="$1"
	classfile="$class".cpp
	if ! create_file "$classfile" ; then return 1 ; fi
	cat >"$classfile" <<CLASSFILE
#include "${class}.h"
#include <iostream>

$class::$class(){
	std::clog << "$class Default Constructor Called" << std::endl;
}

$class::$class( const $class & other ){
	std::clog << "$class Copy Constructor Called" << std::endl;
	(void)other;
}

$class&	$class::operator=( const $class & other ){
	std::clog << "$class Copy Assignment Operator Called" << std::endl;
	(void)other;
	return (*this);
}

$class::~$class(){
	std::clog << "$class Destructor Called" << std::endl;
}
CLASSFILE
	return 0
}

main(){
	local name
	local class_source
	local class_header

	getname
	if [ "$1" = "" ]
	then
		usage
		return 0
	fi
	getpaths "$@"
	if ! create_header "$1" "$dir" ; then return 1; fi
	if ! create_class "$1" "$dir" ; then  return 1; fi
	return 0;
}

main "$@"
