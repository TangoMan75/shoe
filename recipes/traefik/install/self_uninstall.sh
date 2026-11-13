#!/bin/sh

## Uninstall traefik companion from system
##
## @namespace recipes/traefik/install
## @depends src/shell/install/_uninstall
self_uninstall() {
    _uninstall "$0"
}

