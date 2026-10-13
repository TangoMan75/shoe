#!/bin/sh

## {
##   "namespace": "src/shell/hooks",
##   "summary": "Place here commands you need executed first every time (optional)",
##   "requires": [
##     "awk",
##     "sed"
##   ],
##   "depends": [
##     "src/shell/system/_check_installed"
##   ]
## }
_before() {
    _check_installed awk
    _check_installed sed
}

