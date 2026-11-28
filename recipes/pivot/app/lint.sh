#!/bin/sh

## Lint source files
##
## @namespace recipes/pivot/app
## @requires npm
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
lint() {
    _check_installed npm

    _echo_info 'npm run lint\n'
    npm run lint
}

