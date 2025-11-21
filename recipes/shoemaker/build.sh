#!/bin/sh

## Build from given "build.shoe" file
##
## {
##   "depends": [
##     "_build",
##     "_pwd",
##     "echo_danger"
##   ]
## }
build() {
    if [ ! -f "${file}" ]; then
        echo_danger "error: \"${file}\" file not found\n"
        return 1
    fi
    file="$(realpath "${file}")"

    if [ -z "${destination}" ]; then
        destination="$(_pwd)/build"
    fi
    destination="$(realpath "${destination}")"

    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi

    _build "${file}" "${destination}" "${type}"
}

