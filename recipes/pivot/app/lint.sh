#!/bin/sh

## Lint source files
##
## @namespace recipes/pivot/app
## @requires npm
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
lint() {
    _check_installed npm

    _echo_info 'npm run lint\n'
    npm run lint
}

