#!/bin/sh

## Install local SSL certificates
certificates() {
    _check_installed mkcert

    if [ ! -d ./certs ]; then
        echo_info 'mkdir certs\n'
        mkdir certs
    fi

    _install=''
    for domain in \
        ecoter \
        maildev \
        phpmyadmin \
        traefik \
    ; do
        _install="${_install} ${domain}.localhost *.${domain}.localhost"
    done

    if [ ! -f ./certs/local-key.pem ] && [ ! -f ./certs/local-cert.pem ]; then
        echo_info "mkcert -key-file ./certs/local-key.pem -cert-file ./certs/local-cert.pem ${_install}\n"
        # shellcheck disable=SC2086
        mkcert -key-file ./certs/local-key.pem -cert-file ./certs/local-cert.pem ${_install}

        echo_info 'mkcert -install\n'
        mkcert -install
    fi
}

