#!/bin/sh

## Install tools
##
## @namespace recipes/py_entrypoint
## @requires python3
## @depends src/shell/colors/_echo_info
install() {
    _echo_info 'python3 shoemaker.py self-install\n'
    python3 shoemaker.py self-install
}

