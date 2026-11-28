#!/bin/sh

## Check requirements
##
## @namespace recipes/datadome/install
## @requires awk php sed
## @depends src/shell/system/_check_installed.sh
requirements() {
    _check_installed awk
    _check_installed sed
    _check_installed php
}

