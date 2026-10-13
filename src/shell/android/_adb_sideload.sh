#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Sideload given full OTA package to connected device",
##   "requires": [
##     "adb",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/android/_is_device_connected_with_adb",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the input file.",
##       "type": "file",
##       "required": true
##     }
##   ]
## }
_adb_sideload() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_adb_sideload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_adb_sideload: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_adb_sideload: \"$1\" file not found\n"; return 1; fi

    _echo_info "adb sideload \"$1\"\n"
    adb sideload "$1"
}

