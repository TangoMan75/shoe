#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Wipe userdata on connected device",
##   "requires": [
##     "fastboot"
##   ],
##   "depends": [
##     "src/shell/android/_is_device_connected_with_fastboot",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
_fastboot_wipe() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot -w\n'
    fastboot -w
}

