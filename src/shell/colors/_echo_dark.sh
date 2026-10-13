#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print dark text with optional indentation and padding",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_DARK",
##     "_DEFAULT"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "required": true
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
