#!/bin/sh

## Print primary text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_PRIMARY"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_primary() {
    # Synopsis: _echo_primary <STRING> [INDENTATION] [PADDING]
    #  STRING:      Text to display.
    #  INDENTATION: Indentation level (default: 0).
    #  PADDING:     Padding length (default: 0).
    #  note:        Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #               this is why we're calculating the PADDING length on each execution.

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_PRIMARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print secondary text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_SECONDARY"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_secondary() {
    # Synopsis: _echo_secondary <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SECONDARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print success text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_SUCCESS"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_success() {
    # Synopsis: _echo_success <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SUCCESS}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print danger text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DANGER",
##     "_DEFAULT"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_danger() {
    # Synopsis: _echo_danger <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DANGER}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print warning text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_warning() {
    # Synopsis: _echo_warning <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_WARNING}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print info text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_INFO"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_info() {
    # Synopsis: _echo_info <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_INFO}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print light text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_LIGHT"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_light() {
    # Synopsis: _echo_light <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_LIGHT}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print dark text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_DARK"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_dark() {
    # Synopsis: _echo_dark <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DARK}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print error message to STDERR, prefixed with "error: "
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DANGER",
##     "_DEFAULT"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "MESSAGE",
##       "type": "str",
##       "description": "Error message to display.",
##       "nullable": false
##     }
##   ]
## }
_echo_error() {
    # Synopsis: _echo_error <MESSAGE>
    #   MESSAGE: Error message to display.

    printf "${_DANGER}error: %b${_DEFAULT}" "$1" >&2
}

## Print primary alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_PRIMARY",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_primary()   {
    # Synopsis: _alert_primary <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_PRIMARY}" '' "${_ALERT_PRIMARY}" "$1" "${_ALERT_PRIMARY}" ''
}

## Print secondary alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_SECONDARY",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_secondary() {
    # Synopsis: _alert_secondary <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SECONDARY}" '' "${_ALERT_SECONDARY}" "$1" "${_ALERT_SECONDARY}" ''
}

## Print success alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_SUCCESS",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_success()   {
    # Synopsis: _alert_success <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SUCCESS}" '' "${_ALERT_SUCCESS}" "$1" "${_ALERT_SUCCESS}" ''
}

## Print danger alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_DANGER",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_danger()    {
    # Synopsis: _alert_danger <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" ''
}

## Print warning alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_WARNING",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_warning()   {
    # Synopsis: _alert_warning <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_WARNING}" '' "${_ALERT_WARNING}" "$1" "${_ALERT_WARNING}" ''
}

## Print info alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_INFO",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_info()      {
    # Synopsis: _alert_info <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" ''
}

## Print light alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_LIGHT",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_light()      {
    # Synopsis: _alert_light <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" ''
}

## Print dark alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_DARK",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_dark()      {
    # Synopsis: _alert_dark <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DARK}" '' "${_ALERT_DARK}" "$1" "${_ALERT_DARK}" ''
}

