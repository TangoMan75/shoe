#!/bin/sh

## Build app to "dist" folder
##
## {
##   "namespace": "app",
##   "requires": [
##     "npm",
##     "rm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
build() {
    _echo_info 'rm -rf ./dist\n'
    rm -rf ./dist

    _echo_info 'npm run build\n'
    npm run build
}
