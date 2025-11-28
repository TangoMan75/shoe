#!/bin/sh

## List installed packages on connected device
##
## {
##   "namespace": "android",
##   "requires": [
##     "adb"
##   ],
##   "depends": [
##     "_is_device_connected_with_adb",
##     "_echo_error"
##   ]
## }
_list_installed_apks() {
    # Synopsis: _list_installed_apks

    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    # deprecated
    # adb shell pm list packages -f
    adb shell cmd package list packages -f
}

