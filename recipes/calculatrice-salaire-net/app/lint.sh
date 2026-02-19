#!/bin/sh

## Lint and fix files
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
lint() {
    _echo_info 'npm run lint\n'
    npm run lint
}

