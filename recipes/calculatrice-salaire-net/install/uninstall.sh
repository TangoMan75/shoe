#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/install",
##   "summary": "Uninstall app",
##   "requires": [
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
uninstall() {
    _echo_info 'rm -rf node_modules\n'
    rm -rf node_modules

    _echo_info 'rm -rf dist\n'
    rm -rf dist
}

