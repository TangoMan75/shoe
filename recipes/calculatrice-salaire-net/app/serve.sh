#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/app",
##   "summary": "Serve with hot reload at localhost",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
serve() {
    _echo_info 'npm run serve\n'
    npm run serve
}

