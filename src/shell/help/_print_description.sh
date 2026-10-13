#!/bin/sh

## {
##   "namespace": "src/shell/help",
##   "summary": "Print provided text formatted as a description (used by \"help\" command)",
##   "requires": [
##     "fold",
##     "printf"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_warning"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "DESCRIPTION",
##       "description": "A string containing script description.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_print_description() {
    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

