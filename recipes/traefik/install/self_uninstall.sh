#!/bin/sh

## Uninstall traefik companion from system
##
## {
##   "namespace": "install",
##   "depends": [
##     "_uninstall"
##   ]
## }
self_uninstall() {
    _uninstall "$0"
}

