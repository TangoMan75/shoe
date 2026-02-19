#!/bin/sh

## Build app to "dist" folder
##
## {
##   "namespace": "app",
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
build() {
    _check_installed npm

    _echo_info 'rm -rf ./dist/css\n'
    rm -rf ./dist/css

    _echo_info 'rm -rf ./dist/js\n'
    rm -rf ./dist/js

    _echo_info 'npm run build\n'
    npm run build
}
