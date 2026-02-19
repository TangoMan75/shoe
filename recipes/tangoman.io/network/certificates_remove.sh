#!/bin/sh

## Remove local SSL certificates
certificates_remove() {
    _check_installed mkcert

    _echo_info 'rm -f ./certs/local-key.pem\n'
    rm -f ./certs/local-key.pem

    _echo_info 'rm -f ./certs/local-cert.pem\n'
    rm -f ./certs/local-cert.pem

    _echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

