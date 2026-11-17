#!/bin/sh

## Config Let's Encrypt
##
## @namespace recipes/traefik/letsencrypt
## @depends recipes/traefik/letsencrypt/acme
## @depends recipes/traefik/letsencrypt/email
letsencrypt() {
    acme
    email
}

