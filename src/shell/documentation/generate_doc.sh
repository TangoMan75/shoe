#!/bin/sh

## {
##   "namespace": "src/shell/documentation",
##   "summary": "Generate Markdown documentation for current shoe script",
##   "depends": [
##     "src/shell/documentation/_generate_doc"
##   ]
## }
generate_doc() {
    _generate_doc "$0"
}

