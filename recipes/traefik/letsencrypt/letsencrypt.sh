#!/bin/sh

## {
##   "namespace": "recipes/traefik/letsencrypt",
##   "summary": "Config Let's Encrypt",
##   "depends": [
##     "recipes/traefik/letsencrypt/acme",
##     "recipes/traefik/letsencrypt/email"
##   ]
## }
letsencrypt() {
    acme
    email
}

