#!/bin/sh

## Watch with parcel
##
## {
##   "namespace": "app",
##   "requires": [
##     "npm run"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
watch() {
    _echo_info 'npm run watch\n'
    npm run watch
}
