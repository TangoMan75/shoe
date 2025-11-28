#!/bin/sh

## Reboot connected device to bootloader
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
_reboot_bootloader() {
    # Synopsis: _reboot_bootloader

    if _is_device_connected_with_adb; then
        _echo_info 'adb reboot bootloader\n'
        adb reboot bootloader

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        _echo_info 'fastboot reboot bootloader\n'
        fastboot reboot bootloader

        return 0
    fi

    _echo_error '"_reboot_bootloader" device not found.\n'

    return 1
}

