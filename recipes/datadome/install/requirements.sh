#!/bin/sh

## {
##   "namespace": "recipes/datadome/install",
##   "summary": "Check requirements",
##   "requires": [
##     "awk",
##     "php",
##     "sed"
##   ],
##   "depends": [
##     "src/shell/system/_check_installed"
##   ]
## }
requirements() {
    _check_installed awk
    _check_installed sed
    _check_installed php
}

