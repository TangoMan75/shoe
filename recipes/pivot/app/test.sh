#!/bin/sh

## {
##   "namespace": "recipes/pivot/app",
##   "summary": "Run tests",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
test() {
    _check_installed npm

    _echo_info 'npm test\n'
    npm test
}
