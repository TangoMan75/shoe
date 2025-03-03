#!/bin/sh

# Get APK label
#
# {
#   "namespace": "android",
#   "requires": [
#     "aapt"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "FILE_PATH",
#       "type": "file",
#       "description": "The path to the input file.",
#       "nullable": false
#     }
#   ]
# }
_get_apk_label() {
    # Synopsis: _get_apk_label <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    _check_installed aapt

    if [ -z "$1" ]; then echo_danger 'error: _get_apk_label: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_apk_label: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _get_apk_label: \"$1\" file not found\n"; return 1; fi

    aapt dump badging "$1" 2>/dev/null | awk -F "'" '/application-label:/{print $2}'
}

