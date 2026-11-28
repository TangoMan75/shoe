#!/bin/sh

## Pull all user apks to destination folder
##
## @namespace recipes/android/apk
## @requires adb awk basename grep head mkdir mv printf realpath tr
## @depends src/shell/android/_list_installed_apks.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @param {folder} <destination> (default:".") The destination folder.
pull() {
    if [ ! -d "${destination}" ]; then
        _echo_info "mkdir -p \"${destination}\"\n"
        mkdir -p "${destination}"
    fi
    destination="$(realpath "${destination}")"

    for source_apk in $(_list_installed_apks | grep -E "^package:/data/app"); do
        apk_package=$(printf '%s' "${source_apk}" | awk -F '.apk=' '/^package:\/data\/app\//{print $2}')
        _echo_warning "${apk_package}\n"

        apk_version=$(adb shell dumpsys package "${apk_package}" | awk -F '=' '/versionName/{print $2}' | tr ' ' _ | head -n1)
        _echo_success "${apk_version}\n"

        apk_path=$(printf '%s' "${source_apk}" | awk -v NAME="${apk_package}" '{print substr($0, 9, length($0)-length(NAME)-9)}')
        _echo_info "adb pull \"${apk_path}\"\n"
        adb pull "${apk_path}"

        _echo_info "mv \"$(basename "${apk_path}")\" \"$1/${apk_package}.apk\"\n"
        mv "$(basename "${apk_path}")" "$1/${apk_package}.apk"
    done
}

