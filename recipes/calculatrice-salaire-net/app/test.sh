#!/bin/sh

## Run unit tests
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
test() {
    _echo_info 'npm run test:unit\n'
    npm run test:unit
}

