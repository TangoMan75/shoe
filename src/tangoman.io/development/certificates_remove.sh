#!/bin/sh

## Remove local SSL certificates
certificates_remove() {
    if [ ! -x "$(command -v mkcert)" ]; then
        echo_error "\"$(basename "${0}")\" requires mkcert, try: 'sudo apt-get install -y mkcert'\n"
        return 1
    fi

    echo_info 'rm -f ./certs/local-key.pem\n'
    rm -f ./certs/local-key.pem

    echo_info 'rm -f ./certs/local-cert.pem\n'
    rm -f ./certs/local-cert.pem

    echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

