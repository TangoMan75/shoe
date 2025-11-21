#!/bin/sh

# Reboot connected device to system
#
# {
#   "namespace": "android",
#   "requires": [
#     "adb",
#     "fastboot"
#   ],
#   "depends": [
#     "_is_device_connected_with_adb",
#     "_is_device_connected_with_fastboot",
#     "echo_danger",
#     "echo_info"
#   ]
# }
_reboot_system() {
    # Synopsis: _reboot_system

    if _is_device_connected_with_adb; then
        echo_info 'adb reboot system\n'
        adb reboot system

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        echo_info 'fastboot reboot\n'
        fastboot reboot

        return 0
    fi

    echo_danger 'error: "_reboot_system" device not found.'

    return 1
}

