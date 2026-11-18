#!/bin/sh

## Check device is connected with adb
##
## @namespace src/shell/android
## @requires adb tail
## @depends src/shell/system/_check_installed
_is_device_connected_with_adb() {
    _check_installed adb

    if [ "$(adb devices | tail -n2)" = 'List of devices attached' ]; then

        return 1
    fi

    return 0
}

