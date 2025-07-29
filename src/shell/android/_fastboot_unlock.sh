#!/bin/sh

# Unlock bootloader and flashing
_fastboot_unlock() {
    # Synopsis: _fastboot_unlock

    if ! _is_device_connected_with_fastboot; then
        echo_danger 'error: please reboot to bootloader\n'

        return 1
    fi

    echo_info 'fastboot oem unlock || true\n'
    fastboot oem unlock || true

    echo_info 'fastboot flashing unlock || true\n'
    fastboot flashing unlock || true

    echo_info 'fastboot flashing unlock_critical || true\n'
    fastboot flashing unlock_critical || true
}

