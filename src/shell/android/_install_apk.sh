#!/bin/sh

## Install APK on connected device
##
## @namespace src/shell/android
## @requires adb install realpath
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {bool} <FORCE> (default:false) Force install.
## @flag <grant_all> [--grant-all] Grant all runtime permissions.
_install_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_install_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_install_apk: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_install_apk: \"$1\" file not found\n"; return 1; fi

    # "$2": force install (-r), "$3": grant all runtime permissions (-g).
    # Both are opt-in: granting every permission is a deliberate choice,
    # never a default, and installing must not replace a version by
    # accident.
    set -- "$(realpath -- "$1")" "${2:-false}" "${grant_all:-false}"

    __status__=0
    if [ "$2" = 'true' ] && [ "$3" = 'true' ]; then
        _echo_info "adb install -r -g \"$1\"\n"
        adb install -r -g "$1" || __status__=$?
    elif [ "$2" = 'true' ]; then
        _echo_info "adb install -r \"$1\"\n"
        adb install -r "$1" || __status__=$?
    elif [ "$3" = 'true' ]; then
        _echo_info "adb install -g \"$1\"\n"
        adb install -g "$1" || __status__=$?
    else
        _echo_info "adb install \"$1\"\n"
        adb install "$1" || __status__=$?
    fi

    if [ "${__status__}" -ne 0 ]; then
        _echo_error "_install_apk: could not install \"$1\"\n"

        return 1
    fi
}

