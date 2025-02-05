#!/bin/sh

## Generate Markdown documentation for provided shoe script
generate_doc() {
    _generate_doc "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).md" "${private}"
}

