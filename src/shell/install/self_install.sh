#!/bin/sh

## Install script and enable autocompletion
##
## @namespace src/shell/install
## @requires basename
## @depends src/shell/install/_install
## @assumes ALIAS global
self_install() {
    _install "$0" "${ALIAS:-$(basename "$0" .sh)}" "${global:-false}"
}

