#!/bin/sh
mkdir -p man_index ; for i in {1..8} ; do apropos '.*' | grep -E ".*\($i\).*" 1>man_index/man$i\_index ; done
