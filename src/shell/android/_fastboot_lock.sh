#!/bin/sh

# Lock bootloader and flashing
_fastboot_lock() {
    # Synopsis: _fastboot_lock

    if ! _is_device_connected_with_fastboot; then
        echo_danger 'error: please reboot to bootloader\n'

        return 1
    fi

    echo_info 'fastboot oem lock\n'
    fastboot oem lock

    echo_info 'fastboot flashing lock\n'
    fastboot flashing lock

    # echo_info 'fastboot flashing lock_critical\n'
    # fastboot flashing lock_critical
}

