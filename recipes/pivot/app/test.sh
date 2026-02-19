#!/bin/sh

## Run tests
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
test() {
    _check_installed npm

    _echo_info 'npm test\n'
    npm test
}
