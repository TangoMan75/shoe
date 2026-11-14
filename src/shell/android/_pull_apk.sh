#!/bin/sh

## Copy APK from connected device to local folder
##
## @namespace src/shell/android
## @requires adb realpath
## @depends src/shell/android/_get_apk_path src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_pull_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_pull_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_pull_apk: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$(_get_apk_path "$1")" "$(realpath "$2")"
    if [ ! -d "$3" ]; then _echo_error "_pull_apk: \"$3\" folder not found\n"; return 1; fi

    _echo_info "adb pull \"$2\" \"$3/$1.apk\"\n"
    adb pull "$2" "$3/$1.apk"
}

