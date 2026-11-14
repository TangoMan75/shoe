#!/bin/sh

## Check if package is installed on connected device
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
_is_apk_installed() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_is_apk_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_apk_installed: too many arguments ($#)\n"; return 1; fi

    if [ -z "$(adb shell cmd package path "$1")" ]; then

        return 1
    fi

    return 0
}

