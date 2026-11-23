#!/bin/sh

## Reboot connected device to system
##
## @namespace src/shell/android
## @requires adb fastboot reboot
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/android/_is_device_connected_with_fastboot.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
_reboot_system() {
    if _is_device_connected_with_adb; then
        _echo_info 'adb reboot system\n'
        adb reboot system

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        _echo_info 'fastboot reboot\n'
        fastboot reboot

        return 0
    fi

    _echo_error '"_reboot_system" device not found.\n'

    return 1
}

