#!/bin/sh

## Get top-level shoedoc annotation of the provided shoe script file
##
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     }
##   ]
## }
_get_script_shoedoc() {
    # Synopsis: _get_script_shoedoc <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.

    if [ -z "$1" ]; then _echo_error '_get_script_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_script_shoedoc: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_script_shoedoc: \"$1\" file not found\n"; return 1; fi

    awk '
        /^##/ { annotation=annotation$0"\n" }
        !/^##/ {
            if (annotation != "") {
                if ($0 == "") {
                    print annotation
                }
                exit
            }
        }
    ' "$1"
}

