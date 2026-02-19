#!/bin/sh

## Uninstall app
##
## {
##   "namespace": "install",
##   "requires": [
##     "rm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
uninstall() {
    _echo_info 'rm -rf node_modules\n'
    rm -rf node_modules

    _echo_info 'rm -rf dist\n'
    rm -rf dist
}

