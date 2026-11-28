#!/bin/sh

## Check requirements
##
## @namespace recipes/calculatrice-salaire-net/install
## @requires awk sed
## @depends src/shell/system/_check_installed.sh
requirements() {
    _check_installed awk
    _check_installed sed
}

