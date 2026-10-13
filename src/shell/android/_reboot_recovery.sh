#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Reboot connected device to recovery",
##   "requires": [
##     "adb",
##     "fastboot",
##     "reboot"
##   ],
##   "depends": [
##     "src/shell/android/_is_device_connected_with_adb",
##     "src/shell/android/_is_device_connected_with_fastboot",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
_reboot_recovery() {
    # Synopsis: _reboot_recovery

    if _is_device_connected_with_adb; then
        _echo_info 'adb reboot recovery\n'
        adb reboot recovery

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        _echo_info 'fastboot reboot recovery\n'
        fastboot reboot recovery

        return 0
    fi

    _echo_error '"_reboot_recovery" device not found.\n'

    return 1
}

