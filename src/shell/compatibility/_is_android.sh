#!/bin/sh

## Check current system is Android
##
## @namespace src/shell/compatibility
## @requires uname
## @assumes ANDROID_DATA ANDROID_ROOT
_is_android() {
    if [ -n "${ANDROID_DATA}" ] || [ -n "${ANDROID_ROOT}" ]; then

        return 0
    fi

    if [ "$(uname -o 2>/dev/null)" = 'Android' ]; then

        return 0
    fi

    return 1
}

