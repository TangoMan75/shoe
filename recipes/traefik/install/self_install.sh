#!/bin/sh

## Install traefik companion and enable autocompletion
##
## {
##   "namespace": "install",
##   "depends": [
##     "_install"
##   ]
## }
self_install() {
    _install "$0"
}

