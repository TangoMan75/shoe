#!/bin/sh

# Reboot connected device to bootloader
_reboot_bootloader() {
    # Synopsis: _reboot_bootloader

    if _is_device_connected_with_adb; then
        echo_info 'adb reboot bootloader\n'
        adb reboot bootloader

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        echo_info 'fastboot reboot bootloader\n'
        fastboot reboot bootloader

        return 0
    fi

    echo_danger 'error: "_reboot_bootloader" device not found.'

    return 1
}

