#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/network",
##   "summary": "Remove local SSL certificates",
##   "requires": [
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
certificates_remove() {
    _check_installed mkcert

    _echo_info 'rm -f ./certs/local-key.pem\n'
    rm -f ./certs/local-key.pem

    _echo_info 'rm -f ./certs/local-cert.pem\n'
    rm -f ./certs/local-cert.pem

    _echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

