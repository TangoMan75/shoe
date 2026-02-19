#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/app",
##   "summary": "Lint and fix files",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
lint() {
    _echo_info 'npm run lint\n'
    npm run lint
}

