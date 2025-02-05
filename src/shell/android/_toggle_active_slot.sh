#!/bin/sh

# Toggle connected device active slot
_toggle_active_slot() {
    # Synopsis: _toggle_active_slot

    if ! _is_device_connected_with_fastboot; then
        echo_danger 'error: please reboot to bootloader\n'

        return 1
    fi

    echo_info 'fastboot set_active other\n'
    fastboot set_active other
}

