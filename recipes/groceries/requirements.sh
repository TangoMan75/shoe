#!/bin/sh

## Check requirements
##
## @namespace recipes/groceries
## @requires awk sed
## @depends src/shell/system/_check_installed
requirements() {
    _check_installed awk
    _check_installed sed
}

