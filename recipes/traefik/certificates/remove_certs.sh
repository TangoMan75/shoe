#!/bin/sh

## Remove local SSL certificates
##
## @namespace recipes/traefik/certificates
## @requires mkcert rm
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
remove_certs() {
    _check_installed mkcert

    _echo_info 'rm -f ./certs/key.pem\n'
    rm -f ./certs/key.pem

    _echo_info 'rm -f ./certs/cert.pem\n'
    rm -f ./certs/cert.pem

    _echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

