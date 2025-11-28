#!/bin/sh

## Reboot connected device to system
##
## {
##   "namespace": "android",
##   "requires": [
##     "adb",
##     "fastboot"
##   ],
##   "depends": [
##     "_is_device_connected_with_adb",
##     "_is_device_connected_with_fastboot",
##     "_echo_error",
##     "_echo_info"
##   ]
## }
_reboot_system() {
    # Synopsis: _reboot_system

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

