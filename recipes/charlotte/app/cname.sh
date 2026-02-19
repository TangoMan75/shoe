#!/bin/sh

## Dump CNAME file
##
## {
##   "namespace": "app",
##   "assumes": [
##     "domain"
##   ],
##   "requires": [
##     "printf"
##   ]
## }
cname() {
    _echo_info "printf '%s' \"${domain}\" > ./dist/CNAME\n"
    printf '%s' "${domain}" > ./dist/CNAME
}
