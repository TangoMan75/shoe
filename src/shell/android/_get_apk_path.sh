#!/bin/sh

## Get installed APK path on connected device from package name
##
## @namespace src/shell/android
## @requires adb awk
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/colors/_echo_error.sh
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
_get_apk_path() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_get_apk_path: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_path: too many arguments ($#)\n"; return 1; fi

    # The package name is concatenated into a device-side command: only
    # identifiers are allowed, so it cannot inject shell syntax on the device.
    case "$1" in
        ''|*[!A-Za-z0-9._]*)
            _echo_error "_get_apk_path: invalid package name \"$1\"\n"

            return 1
            ;;
    esac

    # deprecated
    # adb shell pm path "$1" | awk -F ':' '{print $2}'
    adb shell cmd package path "$1" | awk -F ':' '{print $2}'
}

