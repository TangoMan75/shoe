#!/bin/sh

## Pull all user apks to destination folder
pull() {
    destination="$(realpath "${destination}")"
    if [ ! -d "${destination}" ]; then
        _echo_info "mkdir -p \"${destination}\"\n"
        mkdir -p "${destination}"
    fi

    for source_apk in $(_list_installed_apks | grep -E "^package:/data/app"); do
        apk_package=$(printf '%s' "${source_apk}" | awk -F '.apk=' '/^package:\/data\/app\//{print $2}')
        _echo_warning "${apk_package}\n"

        apk_version=$(adb shell dumpsys package "${apk_package}" | awk -F '=' '/versionName/{print $2}' | tr ' ' _ | head -n1)
        _echo_success "${apk_version}\n"

        apk_path=$(printf '%s' "${source_apk}" | awk -v NAME="${apk_package}" '{print substr($0, 9, length($0)-length(NAME)-9)}')
        _echo_info "adb pull \"${apk_path}\"\n"
        adb pull "${apk_path}"

        _echo_info "mv \"$(basename "${apk_path}")\" \"${destination}/${apk_package}.apk\"\n"
        mv "$(basename "${apk_path}")" "${destination}/${apk_package}.apk"
    done
}

