#!/bin/sh

## {
##   "namespace": "src/shell/npm",
##   "summary": "Run tests",
##   "requires": [
##     "npm",
##     "test"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
_npm_test() {
    _check_installed npm

    _echo_info 'npm test\n'
    npm test
}
