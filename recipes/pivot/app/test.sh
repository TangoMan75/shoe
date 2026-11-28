#!/bin/sh

## Run tests
##
## @namespace recipes/pivot/app
## @requires npm
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
test() {
    _check_installed npm

    _echo_info 'npm test\n'
    npm test
}

