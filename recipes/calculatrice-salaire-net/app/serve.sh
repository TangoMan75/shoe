#!/bin/sh

## Serve with hot reload at localhost
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
serve() {
    _echo_info 'npm run serve\n'
    npm run serve
}
