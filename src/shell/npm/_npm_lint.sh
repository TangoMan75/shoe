#!/bin/sh

## Lint source files
##
## {
##   "namespace": "npm",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
_npm_lint() {
    _check_installed npm

    _echo_info 'npm run lint\n'
    npm run lint
}
