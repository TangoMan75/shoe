#!/bin/sh

## Watch source folder for changes
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
_npm_watch() {
    _check_installed npm

    _echo_info 'npm run watch\n'
    npm run watch
}
