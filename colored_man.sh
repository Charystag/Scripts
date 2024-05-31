#!/usr/bin/env bash

:<<-'COLORED_MAN'
	Forces `less` to use colors to display man pages
	COLORED_MAN
man() {
LESS_TERMCAP_md=$'\e[01;31m' \
LESS_TERMCAP_me=$'\e[0m' \
LESS_TERMCAP_us=$'\e[01;32m' \
LESS_TERMCAP_ue=$'\e[0m' \
LESS_TERMCAP_so=$'\e[45;93m' \
LESS_TERMCAP_se=$'\e[0m' \
command man "$@"
}

man "$@"
