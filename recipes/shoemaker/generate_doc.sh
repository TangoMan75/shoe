#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Generate Markdown documentation for provided shoe script",
##   "requires": [
##     "basename",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/documentation/_generate_doc"
##   ]
## }
generate_doc() {
    _generate_doc "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).md" "${private}"
}

