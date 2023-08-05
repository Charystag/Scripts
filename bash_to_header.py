#!/bin/python3
import sys

def to_header(line):
	new_line = '\"'
	for i in line :
		if i == '\"' :
			new_line += "\\\""
		elif i == "\t" :
			new_line += "\\t"
		elif i == '\n' :
			new_line += "\\n"
		elif i == '\\' :
			new_line += "\\"
		else :
			new_line += i
	new_line += '\" \\\n'
	return (new_line)

arglen = len(sys.argv)
if (arglen < 2):
	print("Please give filename")
	sys.exit(1)
script_name = sys.argv[1]
with open(script_name, "r") as script :
	for line in script:
		print(to_header(line), end = "")
