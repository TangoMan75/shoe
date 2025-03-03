#!/bin/sh

# Reboot connected device to recovery
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
_reboot_recovery() {
    # Synopsis: _reboot_recovery

    if _is_device_connected_with_adb; then
        echo_info 'adb reboot recovery\n'
        adb reboot recovery

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        echo_info 'fastboot reboot recovery\n'
        fastboot reboot recovery

        return 0
    fi

    echo_danger 'error: "_reboot_recovery" device not found.'

    return 1
}

