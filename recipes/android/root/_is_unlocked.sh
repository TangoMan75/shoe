#!/bin/sh

## Check if the connected device bootloader is unlocked
##
## Reads "ro.boot.flash.locked" when adb is available, and falls back
## to "fastboot getvar unlocked" (or "fastboot oem device-info") when
## the device is in fastboot mode.
##
## @namespace recipes/android/root
## @requires adb fastboot grep sed tr
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/android/_is_device_connected_with_fastboot.sh
_is_unlocked() {
    if _is_device_connected_with_adb; then
        __locked__="$(adb shell getprop ro.boot.flash.locked 2>/dev/null | tr -d '\r')"

        if [ "${__locked__}" = '0' ]; then

            return 0
        fi

        return 1
    fi

    if _is_device_connected_with_fastboot; then
        __unlocked__="$(fastboot getvar unlocked 2>&1 | sed -n 's/.*unlocked: //p' | tr -d '\r')"

        if [ -z "${__unlocked__}" ]; then
            if fastboot oem device-info 2>&1 \
                | grep -q 'Device unlocked: true'; then
                __unlocked__='yes'
            fi
        fi

        if [ "${__unlocked__}" = 'yes' ]; then

            return 0
        fi
    fi

    return 1
}

