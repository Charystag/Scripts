#!/bin/bash
man_index_dir="man_index"
mkdir -p "$man_index_dir"
for i in {1..8}
do apropos '.*' | grep -E ".*\($i\).*" 1>"$man_index_dir"/man"$i"_index
done
