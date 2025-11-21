#!/bin/sh

## Generate Markdown documentation for current shoe script
##
## {
##   "namespace": "documentation",
##   "depends": [
##     "_generate_doc"
##   ]
## }
generate_doc() {
    _generate_doc "$0"
}

