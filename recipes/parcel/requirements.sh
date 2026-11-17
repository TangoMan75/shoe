#!/bin/sh

## Check requirements
##
## @namespace recipes/parcel
## @requires awk npm sed
## @depends src/shell/system/_check_installed
requirements() {
    _check_installed awk
    _check_installed npm
    _check_installed sed
}

