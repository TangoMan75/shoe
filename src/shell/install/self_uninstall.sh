#!/bin/sh

## Uninstall script from system
##
## {
##   "namespace": "install",
##   "depends": [
##     "_uninstall"
##   ],
##   "assumes": [
##     "ALIAS"
##   ]
## }
self_uninstall() {
    _uninstall "$0" "${ALIAS}"
}

