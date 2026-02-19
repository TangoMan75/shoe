#!/bin/sh

## Check requirements
##
## {
##   "namespace": "install",
##   "depends": [
##     "_check_installed"
##   ]
## }
requirements() {
    _check_installed awk
    _check_installed sed
}
