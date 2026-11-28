#!/bin/sh

## Build app to "dist" folder
##
## @namespace recipes/pivot/app
## @requires npm rm
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
build() {
    _check_installed npm

    _echo_info 'rm -rf ./dist/css\n'
    rm -rf ./dist/css

    _echo_info 'rm -rf ./dist/js\n'
    rm -rf ./dist/js

    _echo_info 'npm run build\n'
    npm run build
}

