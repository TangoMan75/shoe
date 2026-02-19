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
    _error=0

    if ! _check_installed awk; then
        _error=1
    fi

    if ! _check_installed sed; then
        _error=1
    fi

    return "${_error}"
}

