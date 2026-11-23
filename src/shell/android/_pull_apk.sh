#!/bin/sh

## Copy APK from connected device to local folder
##
## @namespace src/shell/android
## @requires adb realpath
## @depends src/shell/android/_get_apk_path.sh
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_pull_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_pull_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_pull_apk: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$2" ]; then _echo_error "_pull_apk: \"$2\" folder not found\n"; return 1; fi

    # The package name is both a device-side argument and the local file
    # name built below: only identifiers are allowed, so it cannot address
    # a file outside the destination folder.
    case "$1" in
        ''|*[!A-Za-z0-9._]*)
            _echo_error "_pull_apk: invalid package name \"$1\"\n"

            return 1
            ;;
    esac

    if ! __remote_path__="$(_get_apk_path "$1")"; then
        __remote_path__=''
    fi
    if [ -z "${__remote_path__}" ]; then
        _echo_error "_pull_apk: could not locate the apk for \"$1\"\n"

        return 1
    fi

    set -- "$1" "${__remote_path__}" "$(realpath -- "$2")"

    _echo_info "adb pull \"$2\" \"$3/$1.apk\"\n"
    if ! adb pull "$2" "$3/$1.apk"; then
        _echo_error "_pull_apk: could not pull \"$2\"\n"

        return 1
    fi
}

