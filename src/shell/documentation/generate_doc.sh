#!/bin/sh

## Generate Markdown documentation for current shoe script
##
## @namespace src/shell/documentation
## @depends src/shell/documentation/_generate_doc.sh
generate_doc() {
    _generate_doc "$0"
}

