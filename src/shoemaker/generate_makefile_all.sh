#!/bin/sh

## Generate Makefile for all scripts
generate_makefile_all() {
    build_folder="./build"

    if [ ! -d "${build_folder}" ]; then
        mkdir -p "${build_folder}"
    fi

    find ./build -type f -name '*.sh' | while read -r file_path
    do
        _generate_makefile "${file_path}" "${build_folder}" "$(basename "${file_path}" .sh).makefile"
    done
}

