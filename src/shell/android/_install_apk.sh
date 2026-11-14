#!/bin/sh

## Install APK on connected device
##
## @namespace src/shell/android
## @requires adb install realpath true
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {bool} <FORCE> (default:false) Force install.
_install_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_install_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_install_apk: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_install_apk: \"$1\" file not found\n"; return 1; fi

    if [ "$2" = true ]; then
        # -r: replace existing application
        _echo_info "adb install -r -g \"$1\" || true\n"
        adb install -r -g "$1" || true

        return 0
    fi

    # -g: grant all runtime permissions
    _echo_info "adb install -g \"$1\" || true\n"
    adb install -g "$1" || true
}

