#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Get installed APK path on connected device from package name",
##   "requires": [
##     "adb",
##     "awk"
##   ],
##   "depends": [
##     "src/shell/android/_is_device_connected_with_adb",
##     "src/shell/colors/_echo_error"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "PACKAGE_NAME",
##       "type": "str",
##       "description": "The apk package name. eg: \"org.fdroid.fdroid\"",
##       "required": true
##     }
##   ]
## }
_get_apk_path() {
    # Synopsis: _get_apk_path <PACKAGE_NAME>
    #   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"

    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_get_apk_path: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_path: too many arguments ($#)\n"; return 1; fi

    # deprecated
    # adb shell pm path "$1" | awk -F ':' '{print $2}'
    adb shell cmd package path "$1" | awk -F ':' '{print $2}'
}

