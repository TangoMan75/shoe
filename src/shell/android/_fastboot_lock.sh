#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Lock bootloader and flashing",
##   "requires": [
##     "fastboot"
##   ],
##   "depends": [
##     "src/shell/android/_is_device_connected_with_fastboot",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
_fastboot_lock() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot oem lock\n'
    fastboot oem lock

    _echo_info 'fastboot flashing lock\n'
    fastboot flashing lock

    # _echo_info 'fastboot flashing lock_critical\n'
    # fastboot flashing lock_critical
}

