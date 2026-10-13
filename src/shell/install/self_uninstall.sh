#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Uninstall script from system",
##   "requires": [
##     "basename"
##   ],
##   "depends": [
##     "src/shell/install/_uninstall"
##   ],
##   "assumes": [
##     "ALIAS"
##   ]
## }
self_uninstall() {
    _uninstall "$0" "${ALIAS:-$(basename "$0" .sh)}"
}

