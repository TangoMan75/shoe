#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print primary text with optional indentation and padding",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_DEFAULT",
##     "_PRIMARY"
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
_echo_primary() {
    # Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    # this is why we're calculating the PADDING length on each execution.

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_PRIMARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}
