#!/bin/sh

## Toggle connected device active slot
##
## @namespace src/shell/android
## @requires fastboot
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
_toggle_active_slot() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot set_active other\n'
    fastboot set_active other
}

