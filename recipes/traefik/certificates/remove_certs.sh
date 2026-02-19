#!/bin/sh

## Remove local SSL certificates
##
## {
##   "namespace": "certificates",
##   "requires": [
##     "mkcert",
##     "rm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
remove_certs() {
    _check_installed mkcert

    _echo_info 'rm -f ./certs/key.pem\n'
    rm -f ./certs/key.pem

    _echo_info 'rm -f ./certs/cert.pem\n'
    rm -f ./certs/cert.pem

    _echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

