#!/bin/sh

## Check device is connected with adb
##
## @namespace src/shell/android
## @requires adb grep sed
## @depends src/shell/system/_check_installed.sh
_is_device_connected_with_adb() {
    _check_installed adb

    # Only a device in the "device" state can accept commands: offline,
    # unauthorized and "no permissions" entries are not usable.
    if ! adb devices 2>/dev/null \
        | sed -n '2,$p' \
        | grep -q '[[:space:]]device$'; then

        return 1
    fi

    return 0
}

