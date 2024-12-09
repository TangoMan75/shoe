#!/bin/sh

# Synopsis: echo_* <STRING> [INDENTATION] [PADDING]
#  STRING:       Text to display.
#  INDENTATION:  Indentation level (default: 0).
#  PADDING:      Padding length (default: 0).
#  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
#                this is why we're calculating the PADDING length on each execution.

# Print primary text with optional indentation and padding
echo_primary()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${PRIMARY}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print secondary text with optional indentation and padding
echo_secondary() { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${SECONDARY}%b${DEFAULT}%*s" "$2" '' "$1" "$3" ''; }

# Print success text with optional indentation and padding
echo_success()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${SUCCESS}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print danger text with optional indentation and padding
echo_danger()    { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${DANGER}%b${DEFAULT}%*s"    "$2" '' "$1" "$3" ''; }

# Print warning text with optional indentation and padding
echo_warning()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${WARNING}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print info text with optional indentation and padding
echo_info()      { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${INFO}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''; }

# Print light text with optional indentation and padding
echo_light()     { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${LIGHT}%b${DEFAULT}%*s"     "$2" '' "$1" "$3" ''; }

# Print dark text with optional indentation and padding
echo_dark()      { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${DARK}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''; }

# Synopsis: alert_* <STRING>
#  STRING:  Text to display.

# Print primary alert
alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''; }

# Print secondary alert
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''; }

# Print success alert
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''; }

# Print danger alert
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''; }

# Print warning alert
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''; }

# Print info alert
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''; }

# Print light alert
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''; }

# Print dark alert
alert_dark()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''; }

