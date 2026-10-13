#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Validate a file checksum",
##   "requires": [
##     "awk",
##     "grep",
##     "realpath",
##     "set",
##     "sha256sum"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_check_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "SHA256SUM",
##       "type": "str",
##       "description": "A string containing file checksum.",
##       "required": true
##     }
##   ]
## }
_is_checksum_valid() {
    # Synopsis: _is_checksum_valid <FILE_PATH> <SHA256SUM>
    #   FILE_PATH: The path to the input file.
    #   SHA256SUM: A string containing file checksum.

    _check_installed sha256sum

    if [ $# -lt 2 ]; then _echo_error '_is_checksum_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_checksum_valid: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_is_checksum_valid: \"$1\" file not found\n"; return 1; fi

    sha256sum "$1" | awk '{print $1}' | grep -q "$2"
}

