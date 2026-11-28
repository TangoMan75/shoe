#!/bin/sh

## Build app to "dist" folder
##
## @namespace recipes/calculatrice-salaire-net/app
## @requires npm rm
## @depends src/shell/colors/_echo_info.sh
build() {
    _echo_info 'rm -rf ./dist\n'
    rm -rf ./dist

    _echo_info 'npm run build\n'
    npm run build
}

