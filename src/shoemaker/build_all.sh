#!/bin/sh

## Build all scripts
build_all() {
    build_folder="./build"

    if [ ! -d "${build_folder}" ]; then
        mkdir -p "${build_folder}"
    fi

    find "."/src -type f -name '*.lst' | while read -r file_path
    do
        _build "${file_path}" "${build_folder}" "${type}"
    done
}

