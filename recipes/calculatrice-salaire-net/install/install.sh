#!/bin/sh

## Install app
##
## {
##   "namespace": "install",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
install() {
    _echo_info 'npm install\n'
    npm install
}

