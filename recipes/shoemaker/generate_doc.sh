#!/bin/sh

## Generate Markdown documentation for provided shoe script
##
## {
##   "depends": [
##     "_generate_doc"
##   ]
## }
generate_doc() {
    _generate_doc "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).md" "${private}"
}

