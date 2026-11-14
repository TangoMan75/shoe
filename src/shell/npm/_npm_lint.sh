#!/bin/sh

## Lint source files
##
## @namespace src/shell/npm
## @requires npm
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
_npm_lint() {
    _check_installed npm

    _echo_info 'npm run lint\n'
    npm run lint
}

