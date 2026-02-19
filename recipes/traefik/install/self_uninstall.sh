#!/bin/sh

## {
##   "namespace": "recipes/traefik/install",
##   "summary": "Uninstall traefik companion from system",
##   "depends": [
##     "src/shell/install/_uninstall"
##   ]
## }
self_uninstall() {
    _uninstall "$0"
}

