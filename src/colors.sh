#!/bin/sh

#--------------------------------------------------
# Colors global variables
#--------------------------------------------------

# shellcheck disable=SC2034
{
    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n'; 
    ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m'
}

#--------------------------------------------------
# A semantic set of colors functions
#--------------------------------------------------

# Synopsys: echo_* [string] (indentation) (padding)

echo_primary()   { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${PRIMARY}"   "$2" "$3" "${DEFAULT}"; }
echo_secondary() { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${SECONDARY}" "$2" "$3" "${DEFAULT}"; }
echo_success()   { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${SUCCESS}"   "$2" "$3" "${DEFAULT}"; }
echo_danger()    { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${DANGER}"    "$2" "$3" "${DEFAULT}"; }
echo_warning()   { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${WARNING}"   "$2" "$3" "${DEFAULT}"; }
echo_info()      { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${INFO}"      "$2" "$3" "${DEFAULT}"; }
echo_light()     { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${LIGHT}"     "$2" "$3" "${DEFAULT}"; }
echo_dark()      { if [ $# -eq 1 ]; then set -- 0 0 "$1"; elif [ $# -eq 2 ]; then set -- "$1" 0 "$2"; fi; printf "%*b%b%-*b%b" "$1" '' "${DARK}"      "$2" "$3" "${DEFAULT}"; }

alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''; }
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''; }
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''; }
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''; }
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''; }
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''; }
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''; }
alert_dark()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''; }
