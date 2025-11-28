#!/bin/sh

## Tests if parameter exists in provided ".env" or ".sh" file
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
_has_parameter() {
    # Synopsys : _has_parameter <FILE_PATH> <KEY>
    #   FILE_PATH: The path to the input file.
    #   KEY:       The variable name to get from provided file.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_has_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_has_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_has_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    grep -q "^${2}=" "$1"
}

