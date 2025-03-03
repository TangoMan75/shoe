#!/bin/sh

# Sideload given full OTA package to connected device
#
# {
#   "namespace": "android",
#   "requires": [
#     "adb"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_danger",
#     "echo_info"
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
_adb_sideload() {
    # Synopsis: _adb_sideload <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if ! _is_device_connected_with_adb; then
        echo_danger 'error: device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then echo_danger 'error: _adb_sideload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _adb_sideload: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _adb_sideload: \"$1\" file not found\n"; return 1; fi

    echo_info "adb sideload \"$1\"\n"
    adb sideload "$1"
}

