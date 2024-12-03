#!/bin/sh

# Synopsis: echo_* <STRING> [INDENTATION] [PADDING]
#  STRING:       Text to display.
#  INDENTATION:  Indentation level (default: 0).
#  PADDING:      Padding length (default: 0).
echo_primary()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[97m%-*b\033[0m'    "$2" '' "$3" "$1"; }
echo_secondary() { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[94m%-*b\033[0m'    "$2" '' "$3" "$1"; }
echo_success()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[32m%-*b\033[0m'    "$2" '' "$3" "$1"; }
echo_danger()    { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[31m%-*b\033[0m'    "$2" '' "$3" "$1"; }
echo_warning()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[33m%-*b\033[0m'    "$2" '' "$3" "$1"; }
echo_info()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[95m%-*b\033[0m'    "$2" '' "$3" "$1"; }
echo_light()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[47;90m%-*b\033[0m' "$2" '' "$3" "$1"; }
echo_dark()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[40;37m%-*b\033[0m' "$2" '' "$3" "$1"; }

# Synopsis: alert_* <STRING>
#  STRING:  Text to display.
alert_primary()   { printf '\033[0m\n\033[104;37m%64s\033[0m\n\033[104;37m %-63s\033[0m\n\033[104;37m%64s\033[0m\n\n' '' "$1" ''; }
alert_secondary() { printf '\033[0m\n\033[45;37m%64s\033[0m\n\033[45;37m %-63s\033[0m\n\033[45;37m%64s\033[0m\n\n'    '' "$1" ''; }
alert_success()   { printf '\033[0m\n\033[42;30m%64s\033[0m\n\033[42;30m %-63s\033[0m\n\033[42;30m%64s\033[0m\n\n'    '' "$1" ''; }
alert_danger()    { printf '\033[0m\n\033[41;37m%64s\033[0m\n\033[41;37m %-63s\033[0m\n\033[41;37m%64s\033[0m\n\n'    '' "$1" ''; }
alert_warning()   { printf '\033[0m\n\033[43;30m%64s\033[0m\n\033[43;30m %-63s\033[0m\n\033[43;30m%64s\033[0m\n\n'    '' "$1" ''; }
alert_info()      { printf '\033[0m\n\033[44;37m%64s\033[0m\n\033[44;37m %-63s\033[0m\n\033[44;37m%64s\033[0m\n\n'    '' "$1" ''; }
alert_light()     { printf '\033[0m\n\033[47;90m%64s\033[0m\n\033[47;90m %-63s\033[0m\n\033[47;90m%64s\033[0m\n\n'    '' "$1" ''; }
alert_dark()      { printf '\033[0m\n\033[40;37m%64s\033[0m\n\033[40;37m %-63s\033[0m\n\033[40;37m%64s\033[0m\n\n'    '' "$1" ''; }
