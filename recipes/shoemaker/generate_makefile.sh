#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Generate Markdown documentation for provided shoe script",
##   "requires": [
##     "basename",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/make/_generate_makefile"
##   ]
## }
generate_makefile() {
    _generate_makefile "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).makefile"
}

