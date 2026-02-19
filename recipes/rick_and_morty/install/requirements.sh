#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/install",
##   "summary": "Check requirements",
##   "requires": [
##     "awk",
##     "sed"
##   ],
##   "depends": [
##     "src/shell/system/_check_installed"
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

