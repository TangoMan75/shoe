#!/bin/sh

## Generate random 32 bit string
##
## {
##   "namespace": "strings",
##   "requires": [
##     "openssl"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
_generate_key() {
    # Synopsis: _generate_key

    _check_installed openssl

    _echo_info 'openssl rand -hex 16\n'
    openssl rand -hex 16
}

