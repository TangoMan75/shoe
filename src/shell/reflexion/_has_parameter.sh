#!/bin/sh

## {
##   "namespace": "src/shell/reflexion",
##   "summary": "Tests if parameter exists in provided \".env\" or \".sh\" file",
##   "requires": [
##     "grep",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the input file.",
##       "type": "file",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "KEY",
##       "description": "The variable name to get from provided file.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_has_parameter() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_has_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_has_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_has_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    grep -q "^${2}=" "$1"
}

