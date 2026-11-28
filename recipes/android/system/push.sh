#!/bin/sh

## Push file to sdcard
##
## @namespace recipes/android/system
## @requires adb realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @param {file} <file> /^~?[a-zA-Z0-9/._-]+$/ (required) Path to the input file.
## @param {folder} <remote> /^~?[a-zA-Z0-9/._-]+$/ (default:"/data/media") The remote directory.
push() {
    if [ -z "${file}" ] && [ -z "$1" ]; then
        _echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ -z "${file}" ]; then
        file="$1"
    fi

    if [ -z "${remote}" ]; then
        remote='/'
    fi

    if [ ! -f "${file}" ]; then
        _echo_error "file not found: \"${file}\"\n"
        return 1
    fi

    file="$(realpath "${file}")"

    _echo_info "adb push \"${file}\" \"${remote}\"\n"
    adb push "${file}" "${remote}"
}

