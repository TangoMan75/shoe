#!/bin/sh

## Remove Let's Encrypt SSL Certificates
##
## {
##   "namespace": "letsencrypt",
##   "requires": [
##     "rm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
remove_letsencrypt() {
    _echo_info "rm -f ./config/acme.json\n"
    rm -f ./config/acme.json
}

