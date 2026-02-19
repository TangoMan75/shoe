#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/app",
##   "summary": "Run unit tests",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
test() {
    _echo_info 'npm run test:unit\n'
    npm run test:unit
}

