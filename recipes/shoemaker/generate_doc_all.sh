#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

## Generate Markdown documentation for all scripts
generate_doc_all() {
    doc_folder="$(_pwd)/doc"

    if [ ! -d "${doc_folder}" ]; then
        mkdir -p "${doc_folder}"
    fi

    find "$(_pwd)/build" -type f -name '*.sh' | while read -r file_path
    do
        _generate_doc "${file_path}" "${doc_folder}" "$(basename "${file_path}" .sh).md" "${private}"
    done
}

