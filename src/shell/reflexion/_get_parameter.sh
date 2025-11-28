#!/bin/sh

## Get value for given parameter from provided ".env" or ".sh" file
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "KEY",
##       "type": "str",
##       "description": "The variable name to get from provided file.",
##       "nullable": false
##     }
##   ]
## }
_get_parameter() {
    # Synopsys : _get_parameter <FILE_PATH> <KEY>
    #   FILE_PATH: The path to the input file.
    #   KEY:       The variable name to get from provided file.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_get_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    sed -n "s/^$2=\(.*\)/\1/p" "$1" | sed 's/^"//; s/"$//' # remove leading and trailing quotes
}

