#!/bin/sh

## Remove APK from connected device
##
## @namespace src/shell/android
## @requires adb true
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
## @param {bool} <FORCE> (default:false) Force install.
_remove_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_remove_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove_apk: too many arguments ($#)\n"; return 1; fi

    # The package name is concatenated into a device-side command: only
    # identifiers are allowed, so it cannot inject shell syntax on the device.
    case "$1" in
        ''|*[!A-Za-z0-9._]*)
            _echo_error "_remove_apk: invalid package name \"$1\"\n"

            return 1
            ;;
    esac

    set -- "$1" "${2:-false}"

    if [ "$2" = true ]; then
        # deprecated
        # adb shell pm uninstall --user 0 "$1" || true

        _echo_info "adb shell cmd package uninstall --user 0 \"$1\"\n"
        if ! adb shell cmd package uninstall --user 0 "$1"; then
            _echo_error "_remove_apk: could not remove \"$1\"\n"

            return 1
        fi

        return 0
    fi

    _echo_info "adb uninstall \"$1\"\n"
    if ! adb uninstall "$1"; then
        _echo_error "_remove_apk: could not remove \"$1\"\n"

        return 1
    fi
}

