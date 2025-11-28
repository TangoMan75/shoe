#!/bin/sh

## Get file extension
##
## {
##   "namespace": "files",
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     }
##   ]
## }
_get_file_extension() {
    # Synopsis: _get_file_extension <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then _echo_error '_get_file_extension: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_file_extension: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$'
}

