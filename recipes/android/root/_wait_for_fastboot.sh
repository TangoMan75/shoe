#!/bin/sh

## Wait for the device to be available in fastboot mode
##
## @namespace recipes/android/root
## @requires sleep
## @depends src/shell/android/_is_device_connected_with_fastboot.sh
## @depends src/shell/colors/_echo_error.sh
## @param {int} <TIMEOUT> (default:60) Maximum number of seconds to wait.
_wait_for_fastboot() {
    set -- "${1:-60}" 0

    while [ "$2" -lt "$1" ]; do
        if _is_device_connected_with_fastboot; then
            return 0
        fi

        sleep 2
        set -- "$1" "$(($2 + 2))"
    done

    _echo_error '_wait_for_fastboot: timeout waiting for fastboot\n'

    return 1
}

