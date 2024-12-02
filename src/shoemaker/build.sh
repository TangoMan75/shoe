#!/bin/sh

## Build from given "build.lst" file
build() {
    if [ -z "${destination}" ]; then
        destination="${_project_directory}/build"
    fi
    destination="$(realpath "${destination}")"

    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi

    _build "${file}" "${destination}" "${type}"
}

