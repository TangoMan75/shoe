#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print error message to STDERR, prefixed with \"error: \"",
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
##       "name": "MESSAGE",
##       "description": "Error message to display.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_echo_error() {
    printf "${_DANGER}error: %b${_DEFAULT}" "$1" >&2
}
