#!/bin/sh

# Get installed APK path on connected device from package name
_get_apk_path() {
    # Synopsis: _get_apk_path <PACKAGE_NAME>
    #   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"

    if ! _is_device_connected_with_adb; then
        echo_danger 'error: device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then echo_danger 'error: _get_apk_path: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_apk_path: too many arguments (${#})\n"; return 1; fi

    # deprecated
    # adb shell pm path "$1" | awk -F ':' '{print $2}'
    adb shell cmd package path "$1" | awk -F ':' '{print $2}'
}

