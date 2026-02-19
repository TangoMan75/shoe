#!/bin/sh

## Push file to sdcard
##
## {
##   "namespace": "system",
##   "requires": [
##     "adb"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ]
## }
push() {
    if [ -z "${file}" ] && [ -z "$1" ]; then
        _echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ -z "${file}" ]; then
        file="$(realpath "$1")"
    fi

    if [ -z "${remote}" ]; then
        remote='/'
    fi

    if [ ! -f "${file}" ]; then
        _echo_error "file not found: \"${file}\"\n"
        return 1
    fi

    _echo_info "adb push \"${file}\" \"${remote}\"\n"
    adb push "${file}" "${remote}"
}

