#!/bin/sh

## Run tests
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
_npm_test() {
    _check_installed npm

    _echo_info 'npm test\n'
    npm test
}
