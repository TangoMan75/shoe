#!/bin/sh

# Print primary text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_primary() {
    # Synopsis: echo_primary <STRING> [INDENTATION] [PADDING]
    #  STRING:      Text to display.
    #  INDENTATION: Indentation level (default: 0).
    #  PADDING:     Padding length (default: 0).
    #  note:        Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #               this is why we're calculating the PADDING length on each execution.

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${PRIMARY}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print secondary text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_secondary() {
    # Synopsis: echo_secondary <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${SECONDARY}%b${DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

# Print success text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_success() {
    # Synopsis: echo_success <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${SUCCESS}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print danger text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_danger() {
    # Synopsis: echo_danger <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${DANGER}%b${DEFAULT}%*s"    "$2" '' "$1" "$3" ''
}

# Print warning text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_warning() {
    # Synopsis: echo_warning <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${WARNING}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print info text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_info() {
    # Synopsis: echo_info <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${INFO}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''
}

# Print light text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_light() {
    # Synopsis: echo_light <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${LIGHT}%b${DEFAULT}%*s"     "$2" '' "$1" "$3" ''
}

# Print dark text with optional indentation and padding
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "INDENTATION",
#       "type": "int",
#       "description": "Indentation level.",
#       "default": 0
#     },
#     {
#       "position": 3,
#       "name": "PADDING",
#       "type": "int",
#       "description": "Padding length.",
#       "default": 0
#     }
#   ]
# }
echo_dark() {
    # Synopsis: echo_dark <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${DARK}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''
}

# Print primary alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_primary()   {
    # Synopsis: alert_primary <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''
}

# Print secondary alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_secondary() {
    # Synopsis: alert_secondary <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''
}

# Print success alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_success()   {
    # Synopsis: alert_success <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''
}

# Print danger alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_danger()    {
    # Synopsis: alert_danger <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''
}

# Print warning alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_warning()   {
    # Synopsis: alert_warning <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''
}

# Print info alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_info()      {
    # Synopsis: alert_info <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''
}

# Print light alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_light()     {
    # Synopsis: alert_light <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''
}

# Print dark alert
#
# {
#   "namespace": "colors",
#   "parameters": [
#     {
#       "position": 1,
#       "name": "STRING",
#       "type": "str",
#       "description": "Text to display.",
#       "nullable": false
#     }
#   ]
# }
alert_dark()      {
    # Synopsis: alert_dark <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''
}

