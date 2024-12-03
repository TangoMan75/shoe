#!/bin/sh

## Build all scripts
build_all() {
    build_folder="${_project_directory}/build"

    doc_folder="${_project_directory}/doc"

    if [ ! -d "${build_folder}" ]; then
        mkdir -p "${build_folder}"
    fi
    if [ ! -d "${doc_folder}" ]; then
        mkdir -p "${doc_folder}"
    fi
    find "${_project_directory}"/src -type f -name '*.lst' | while read -r file_path
    do
        _build "${file_path}" "${build_folder}" "${type}"
    done
    find "${_project_directory}"/build -type f -name '*.sh' | while read -r file_path
    do
        _generate_doc "${file_path}" "${doc_folder}"
    done
}

