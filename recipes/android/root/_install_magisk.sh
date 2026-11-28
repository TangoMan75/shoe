#!/bin/sh

## Flash a Magisk APK with TWRP
##
## @namespace recipes/android/root
## @requires adb cp mktemp rm tr
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_warning.sh
## @assumes TMPDIR
## @param {file} <FILE_PATH> (required) Path to the Magisk APK.
_install_magisk() {
    if [ -z "$1" ]; then
        _echo_error '_install_magisk: some mandatory parameter is missing\n'

        return 1
    fi

    if [ $# -gt 1 ]; then
        _echo_error "_install_magisk: too many arguments ($#)\n"

        return 1
    fi

    if [ ! -f "$1" ]; then
        _echo_error "_install_magisk: \"$1\" file not found\n"

        return 1
    fi

    _echo_info "adb push \"$1\" /tmp/Magisk.zip\n"
    adb push "$1" /tmp/Magisk.zip || return 1

    if [ -n "$(adb shell 'command -v twrp' 2>/dev/null | tr -d '\r')" ]; then
        _echo_info 'adb shell twrp install /tmp/Magisk.zip\n'
        if adb shell 'twrp install /tmp/Magisk.zip'; then
            return 0
        fi

        _echo_warning 'twrp install failed, falling back to adb sideload\n'
    fi

    __zip__="$(mktemp "${TMPDIR:-/tmp}/magisk.XXXXXX")" || return 1
    cp "$1" "${__zip__}" || {
        rm -f "${__zip__}"

        return 1
    }

    _echo_info "adb sideload \"${__zip__}\"\n"
    adb sideload "${__zip__}"
    __status__=$?
    rm -f "${__zip__}"

    return "${__status__}"
}

