#!/bin/sh

## {
##   "namespace": "recipes/parcel/app",
##   "summary": "Install App with npm",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
install() {
    _echo_info 'npm install\n'
    npm install
}

