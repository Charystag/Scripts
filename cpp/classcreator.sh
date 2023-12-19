#!/usr/bin/env sh

usage(){
	cat <<-"USAGE"
	Usage: classcreator.sh classname [dir] [header_dir class_dir]
	Examples:
		-classcreator.sh classname -> creates a classname.cpp and classname.h class file in the current directory
		-classcreator.sh classname dir -> creates a dir/classname.cpp and dir/classname.h 
		class file in the specified directory
		-classcreator.sh classname header_dir class_dir -> creates a header_dir/classcreator.h and a 
		class_dir/classname.cpp file in the specified directories for header files and source files
	USAGE
}

if [ "$1" = "" ]
then
	usage
	return 0
fi
