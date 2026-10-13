#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print danger text with optional indentation and padding",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_DANGER",
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
_echo_danger() {
    # Synopsis: _echo_danger <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DANGER}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}
