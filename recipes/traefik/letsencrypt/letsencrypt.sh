#!/bin/sh

## Config Let's Encrypt
##
## {
##   "namespace": "letsencrypt",
##   "depends": [
##     "acme",
##     "email"
##   ]
## }
letsencrypt() {
    acme
    email
}

