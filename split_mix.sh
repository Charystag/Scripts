#!/usr/bin/env bash

function error_exit {
	if test "$1";
	then echo "$1" 2>&1; kill -INT $$; fi
	if test "$2";
	then exit "$2"; else exit 1; fi
	return 1;
}

function retrieve_timecodes {
	declare description="$1";

	if ! test -f "$description";
	then error_exit "file \`$1' not found"; fi
	timecodes="$(mktemp || error_exit "Couldn't create timecodes file")"
	grep -E '^[0-9]+:{1}.*' "$description"> "$timecodes"
}

function get_stamp {
	declare -i fd;
	declare stamp;
	declare timecode;
	declare name;

	if test "$1";
	then fd="$1"; else fd=3; fi
	if test "$output_stamp"; then
	input_stamp="$output_stamp"; 
	track_name="$tmp_name"; fi
	if ! read -u "$fd" timecode;
	then return 1; fi
	stamp="$(echo "$timecode" | grep -E -o '^[^ ]+')";
	name="$(echo "$timecode" | grep -E -o ' +.*' | grep -E -o '[^ ]{1}.*')";
	if ! test "$input_stamp"; then input_stamp="$stamp";
	else output_stamp="$stamp"; fi
	if ! test "$track_name"; then track_name="$name";
	else tmp_name="$name"; fi
	return 0;
}

function get_tracks {
	declare -i i=0;
	declare input_stamp;
	declare output_stamp;
	declare track_name;
	declare tmp_name;
	declare timecodes="$1";
	declare mix="$2";

	while get_stamp 3; do
	if test "$output_stamp";
	then ffmpeg -ss "$input_stamp" -to "$output_stamp" -i "$mix" "${dirname:-.}/$track_name".mp3; fi
	done 3<"$timecodes";
	if ! test "$output_stamp";
	then error_exit "Problem converting mix"; fi
	ffmpeg -ss "$input_stamp" -i "$mix" "${dirname:-.}/$track_name".mp3
}

function split_mix {
	declare mix="$1";
	declare mime;

	if ! test -f "$timecodes";
	then error_exit "No timecodes found"; fi
	if ! test -f "$mix";
	then error_exit "mix: \`$mix' not found"; fi
	mime="$(file -b --mime-type "$mix")";
	if test "$mime" != "audio/mpeg";
	then error_exit "mix: \`$mix' is not an audio file"; fi
	if ! which ffmpeg &>/dev/null;
	then error_exit "ffmpeg command not found"; fi
	get_tracks "$timecodes" "$mix";
}

function main {
	declare description;
	declare mix;
	declare timecodes;
	declare dirname;
	declare optvar;
	declare optstring="d:";

	while getopts "$optstring" optvar; do
	case "$optvar" in 
		d) dirname="$OPTARG";
		if ! test -d "$dirname"; then mkdir -p "$dirname"; fi;;
		*) error_exit "usage: split_mix [-d dirname] mix";;
	esac;done
	shift $((OPTIND - 1));
	OPTIND=1;
	if ! test "$2";
	then error_exit "usage: split_mix [-d dirname] description_file mix"; fi
	description="$1";
	mix="$2";
	retrieve_timecodes "$description";
	split_mix "$mix";
}
