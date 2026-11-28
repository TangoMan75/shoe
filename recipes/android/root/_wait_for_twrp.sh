#!/bin/sh

## Wait for the device to be available in TWRP or PBRP
##
## @namespace recipes/android/root
## @requires adb sleep tr true
## @depends src/shell/colors/_echo_error.sh
## @param {int} <TIMEOUT> (default:120) Maximum number of seconds to wait.
_wait_for_twrp() {
    set -- "${1:-120}" 0

    while [ "$2" -lt "$1" ]; do
        if [ "$(adb get-state 2>/dev/null | tr -d '\r')" = 'recovery' ]
        then
            if adb shell true >/dev/null 2>&1; then
                return 0
            fi
        fi

        if [ -n "$(adb shell getprop ro.twrp.version \
            2>/dev/null | tr -d '\r')" ]; then
            return 0
        fi

        if [ -n "$(adb shell getprop ro.pbrp.version \
            2>/dev/null | tr -d '\r')" ]; then
            return 0
        fi

        sleep 2
        set -- "$1" "$(($2 + 2))"
    done

    _echo_error '_wait_for_twrp: timeout waiting for recovery\n'

    return 1
}

