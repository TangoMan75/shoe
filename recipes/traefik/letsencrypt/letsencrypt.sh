#!/bin/sh

## Config Let's Encrypt
##
## @namespace recipes/traefik/letsencrypt
## @depends recipes/traefik/letsencrypt/acme recipes/traefik/letsencrypt/email
letsencrypt() {
    acme
    email
}

