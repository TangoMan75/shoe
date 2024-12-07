#!/bin/sh

## Remove local SSL certificates or acme.json
remove_certs() {
    if [ "${env}" = prod ]; then
        echo_info "rm -f ./config/acme.json\n"
        rm -f ./config/acme.json

        return 0
    fi

    echo_info 'rm -f ./certs/key.pem\n'
    rm -f ./certs/key.pem

    echo_info 'rm -f ./certs/cert.pem\n'
    rm -f ./certs/cert.pem

    echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

