#!/bin/sh

# Copy APK from connected device to local folder
_pull_apk() {
    # Synopsis: _pull_apk <PACKAGE_NAME> <DESTINATION>
    #   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"
    #   DESTINATION:  The path to the destination folder.

    if ! _is_device_connected_with_adb; then
        echo_danger 'error: device not found\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _pull_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _pull_apk: too many arguments (${#})\n"; return 1; fi

    set -- "$1" "$(_get_apk_path "$1")" "$(realpath "$2")"
    if [ ! -d "$2" ]; then echo_danger "error: _pull_apk: \"$2\" folder not found\n"; return 1; fi

    echo_info "adb pull \"$2\" \"$3/$1.apk\"\n"
    adb pull "$2" "$3/$1.apk"
}

