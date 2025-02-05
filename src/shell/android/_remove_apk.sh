#!/bin/sh

# Remove APK from connected device
_remove_apk() {
    # Synopsis: _remove_apk <PACKAGE_NAME> [FORCE]
    #   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"
    #   FORCE:        (optional) Force install. Defaults to "false".

    if ! _is_device_connected_with_adb; then
        echo_danger 'error: device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then echo_danger 'error: _remove_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _remove_apk: too many arguments (${#})\n"; return 1; fi

    set -- "$1" "${2:-false}"

    if [ "$2" = true ]; then
        # deprecated
        # adb shell pm uninstall --user 0 "$1" || true

        echo_info "adb shell cmd package uninstall --user 0 \"$1\" || true\n"
        adb shell cmd package uninstall --user 0 "$1" || true

        return 0
    fi

    echo_info "adb uninstall \"$1\" || true\n"
    adb uninstall "$1" || true
}

