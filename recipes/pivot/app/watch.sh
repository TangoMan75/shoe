#!/bin/sh

## Watch source folder for changes
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
watch() {
    _check_installed npm

    _echo_info 'npm run watch\n'
    npm run watch
}
