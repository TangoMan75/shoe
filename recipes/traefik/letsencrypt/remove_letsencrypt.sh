#!/bin/sh

## Remove Let's Encrypt SSL Certificates
##
## @namespace recipes/traefik/letsencrypt
## @requires rm
## @depends src/shell/colors/_echo_info
remove_letsencrypt() {
    _echo_info "rm -f ./config/acme.json\n"
    rm -f ./config/acme.json
}

