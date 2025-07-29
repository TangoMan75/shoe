#!/bin/sh

# Wipe userdata on connected device
_fastboot_wipe() {
    # Synopsis: _fastboot_wipe

    if ! _is_device_connected_with_fastboot; then
        echo_danger 'error: please reboot to bootloader\n'

        return 1
    fi

    echo_info 'fastboot -w\n'
    fastboot -w
}

