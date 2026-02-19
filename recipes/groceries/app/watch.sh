#!/bin/sh

## {
##   "namespace": "recipes/groceries/app",
##   "summary": "Watch with parcel",
##   "requires": [
##     "yarn"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
watch() {
    _echo_info 'yarn watch\n'
    yarn watch
}
