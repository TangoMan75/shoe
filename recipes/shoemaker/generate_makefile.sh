#!/bin/sh

## Generate Markdown documentation for provided shoe script
generate_makefile() {
    _generate_makefile "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).makefile"
}

