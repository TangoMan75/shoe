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
##   "parameters": [
##     {
##       "position": 1,
##       "name": "DESCRIPTION",
##       "type": "str",
##       "description": "A string containing script description.",
##       "nullable": false
##     }
##   ]
## }
_print_description() {
    # Synopsis: _print_description <DESCRIPTION>
    #   DESCRIPTION: A string containing script description.

    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

