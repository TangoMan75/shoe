#!/bin/sh

## Generate Markdown documentation for provided shoe script
##
## @namespace recipes/shoemaker
## @requires basename realpath
## @depends src/shell/make/_generate_makefile
## @assumes destination file
generate_makefile() {
    _generate_makefile "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).makefile"
}

