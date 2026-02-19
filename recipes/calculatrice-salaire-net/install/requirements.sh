#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/install",
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
    _check_installed awk
    _check_installed sed
}

