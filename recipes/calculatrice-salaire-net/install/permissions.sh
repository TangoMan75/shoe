#!/bin/sh

## Fix permissions
##
## @namespace recipes/calculatrice-salaire-net/install
## @requires chown sudo
## @depends src/shell/colors/_echo_info
## @assumes USER
permissions() {
    _echo_info "sudo chown \"${USER}:${USER}\" -R ./dist\n"
    sudo chown "${USER}:${USER}" -R ./dist
}

