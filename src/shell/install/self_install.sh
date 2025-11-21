#!/bin/sh

## Install script and enable completion
##
## {
##   "namespace": "install",
##   "depends": [
##     "_install"
##   ],
##   "assumes": [
##     "ALIAS",
##     "global"
##   ]
## }
self_install() {
    _install "$0" "${ALIAS}" "${global:-false}"
}

