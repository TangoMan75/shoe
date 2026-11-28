#!/bin/sh

## Config Let's Encrypt
##
## @namespace recipes/traefik/letsencrypt
## @depends recipes/traefik/letsencrypt/acme.sh
## @depends recipes/traefik/letsencrypt/email.sh
letsencrypt() {
    acme
    email
}

