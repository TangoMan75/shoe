#!/bin/sh

## {
##   "namespace": "recipes/parcel/app",
##   "summary": "Watch with parcel",
##   "requires": [
##     "npm",
##     "npm run"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
watch() {
    _echo_info 'npm run watch\n'
    npm run watch
}
