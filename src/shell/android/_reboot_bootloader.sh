#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Reboot connected device to bootloader",
##   "requires": [
##     "adb",
##     "fastboot",
##     "reboot"
##   ],
##   "depends": [
##     "src/shell/android/_is_device_connected_with_adb",
##     "src/shell/android/_is_device_connected_with_fastboot",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
_reboot_bootloader() {
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

