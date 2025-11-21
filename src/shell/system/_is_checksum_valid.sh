#!/bin/sh

# Validate a file checksum
#
# {
#   "namespace": "system",
#   "requires": [
#     "awk",
#     "sha256sum"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "FILE_PATH",
#       "type": "file",
#       "description": "The path to the input file.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "SHA256SUM",
#       "type": "str",
#       "description": "A string containing file checksum.",
#       "nullable": false
#     }
#   ]
# }
_is_checksum_valid() {
    # Synopsis: _is_checksum_valid <FILE_PATH> <SHA256SUM>
    #   FILE_PATH: The path to the input file.
    #   SHA256SUM: A string containing file checksum.

    _check_installed sha256sum

    if [ $# -lt 2 ]; then echo_danger 'error: _is_checksum_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then echo_danger "error: _is_checksum_valid: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _is_checksum_valid: \"$1\" file not found\n"; return 1; fi

    sha256sum "$1" | awk '{print $1}' | grep -q "$2"
}

