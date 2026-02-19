#!/bin/sh

## Install App with npm
##
## {
##   "namespace": "app",
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
