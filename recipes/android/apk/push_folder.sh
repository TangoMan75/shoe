#!/bin/sh

## Copy folder content to phone
##
## {
##   "namespace": "apk",
##   "requires": [
##     "adb"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ]
## }
push_folder() {
    source="$(realpath "${source}")"
    if [ ! -d "${source}" ]; then
        _echo_error "folder not found : \"${source}\"\n"
        return 1
    fi

    remote=$(adb shell realpath "${remote}")

    find "${source}" -maxdepth 1 -type f | sort -t '\0' -n | while read -r file
    do
        _echo_info "adb push \"${file}\" \"${remote}\"\n"
        adb push "${file}" "${remote}"
    done
}

