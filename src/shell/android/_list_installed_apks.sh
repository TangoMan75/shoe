#!/bin/sh

# List installed packages on connected device
_list_installed_apks() {
    # Synopsis: _list_installed_apks

    if ! _is_device_connected_with_adb; then
        echo_danger 'error: device not found\n'

        return 1
    fi

    # deprecated
    # adb shell pm list packages -f
    adb shell cmd package list packages -f
}

