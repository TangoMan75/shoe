#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Install script and enable autocompletion",
##   "requires": [
##     "basename"
##   ],
##   "depends": [
##     "src/shell/install/_install"
##   ],
##   "assumes": [
##     "ALIAS",
##     "global"
##   ]
## }
self_install() {
    _install "$0" "${ALIAS:-$(basename "$0" .sh)}" "${global:-false}"
}

