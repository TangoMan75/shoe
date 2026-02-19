#!/bin/sh

## {
##   "namespace": "recipes/charlotte/app",
##   "summary": "Dump CNAME file",
##   "requires": [
##     "printf"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ],
##   "assumes": [
##     "domain"
##   ]
## }
cname() {
    _echo_info "printf '%s' \"${domain}\" > ./dist/CNAME\n"
    printf '%s' "${domain}" > ./dist/CNAME
}

