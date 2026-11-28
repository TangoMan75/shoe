#!/bin/sh

## Copy folder content to phone
##
## @namespace recipes/android/apk
## @requires adb file find realpath sort
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @assumes source
push_folder() {
    if [ ! -d "${source}" ]; then
        _echo_error "folder not found : \"${source}\"\n"
        return 1
    fi
    source="$(realpath "${source}")"

    remote=$(adb shell realpath "${remote}")

    find "${source}" -maxdepth 1 -type f | sort -t '\0' -n | while read -r file
    do
        _echo_info "adb push \"${file}\" \"${remote}\"\n"
        adb push "${file}" "${remote}"
    done
}

