#!/bin/sh

## Uninstall app
##
## @namespace recipes/calculatrice-salaire-net/install
## @requires rm
## @depends src/shell/colors/_echo_info.sh
uninstall() {
    _echo_info 'rm -rf node_modules\n'
    rm -rf node_modules

    _echo_info 'rm -rf dist\n'
    rm -rf dist
}

