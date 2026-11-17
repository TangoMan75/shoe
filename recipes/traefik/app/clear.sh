#!/bin/sh

## Clear logs
##
## @namespace recipes/traefik/app
## @requires rm true
## @depends src/shell/colors/_echo_info
clear() {
    _echo_info 'rm -f ./logs/*.log || true\n'
    rm -f ./logs/*.log || true
}

