#!/bin/sh

## Watch with parcel
##
## {
##   "namespace": "app",
##   "requires": [
##     "yarn"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
watch() {
    _echo_info 'yarn watch\n'
    yarn watch
}
