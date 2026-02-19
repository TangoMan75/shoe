#!/bin/sh

## Create empty Let's Encrypt acme.json file
##
## {
##   "namespace": "letsencrypt",
##   "requires": [
##     "chmod",
##     "touch"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
acme() {
    _echo_info 'touch ./config/acme.json\n'
    touch ./config/acme.json

    _echo_info 'chmod 600 ./config/acme.json\n'
    chmod 600 ./config/acme.json
}

