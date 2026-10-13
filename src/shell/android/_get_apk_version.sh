#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Get APK version",
##   "requires": [
##     "aapt",
##     "awk",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_check_installed"
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
_get_apk_version() {
    _check_installed aapt

    if [ -z "$1" ]; then _echo_error '_get_apk_version: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_version: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_apk_version: \"$1\" file not found\n"; return 1; fi

    # adb shell dumpsys package "${apk_package}" | awk -F '=' '/versionName/{print $2}' | tr ' ' _ | head -n1
    aapt dump badging "$1" 2>/dev/null | awk '/package/{gsub("versionName=|'"'"'","");  print $4}'
}

