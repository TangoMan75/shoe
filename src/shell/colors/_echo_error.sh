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
