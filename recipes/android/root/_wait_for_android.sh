#!/bin/sh

## Wait for the device to finish booting Android
##
## @namespace recipes/android/root
## @requires adb sleep tr
## @depends src/shell/colors/_echo_error.sh
## @param {int} <TIMEOUT> (default:120) Maximum number of seconds to wait.
_wait_for_android() {
    set -- "${1:-120}" 0

    while [ "$2" -lt "$1" ]; do
        if [ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = '1' ]; then
            return 0
        fi

        sleep 2
        set -- "$1" "$(($2 + 2))"
    done

    _echo_error '_wait_for_android: timeout waiting for Android\n'

    return 1
}

