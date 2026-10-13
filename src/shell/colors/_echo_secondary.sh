#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print secondary text with optional indentation and padding",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_DEFAULT",
##     "_SECONDARY"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "description": "Text to display.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "description": "Indentation level.",
##       "type": "int",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "description": "Padding length.",
##       "type": "int",
##       "default": 0
##     }
##   ]
## }
_echo_secondary() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SECONDARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}
