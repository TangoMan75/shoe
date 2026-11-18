#!/bin/sh

## Check device is connected with fastboot
##
## @namespace src/shell/android
## @requires fastboot
## @depends src/shell/system/_check_installed
_is_device_connected_with_fastboot() {
    _check_installed fastboot

    if [ -z "$(fastboot devices)" ]; then

        return 1
    fi

    return 0
}

