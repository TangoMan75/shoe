#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/install",
##   "summary": "Install app",
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

