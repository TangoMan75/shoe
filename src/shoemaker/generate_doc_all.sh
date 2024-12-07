#!/bin/sh

## Generate Markdown documentation for all scripts
generate_doc_all() {
    doc_folder="./doc"

    if [ ! -d "${doc_folder}" ]; then
        mkdir -p "${doc_folder}"
    fi

    find ./build -type f -name '*.sh' | while read -r file_path
    do
        _generate_doc "${file_path}" "${doc_folder}" "$(basename "${file_path}" .sh).md" "${private}"
    done
}

