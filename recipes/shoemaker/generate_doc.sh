#!/bin/sh

## Generate Markdown documentation for provided shoe script
##
## @namespace recipes/shoemaker
## @requires basename realpath
## @depends src/shell/documentation/_generate_doc
## @assumes destination file private
generate_doc() {
    _generate_doc "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).md" "${private}"
}

