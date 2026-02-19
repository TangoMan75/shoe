#!/bin/sh

## Lint source files
##
## {
##   "namespace": "app",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
lint() {
    _check_installed npm

    _echo_info 'npm run lint\n'
    npm run lint
}
