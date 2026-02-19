#!/bin/sh

## Build app to "dist" folder
##
## {
##   "namespace": "app",
##   "depends": [
##     "_echo_info"
##   ]
## }
build() {
    _echo_info 'rm -rf ./dist\n'
    rm -rf ./dist

    _echo_info 'mkdir ./dist\n'
    mkdir ./dist

    _echo_info 'yarn build\n'
    yarn build
}
