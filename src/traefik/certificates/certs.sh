#!/bin/sh

## Install local SSL certificates
certs() {
    if [ ! -f .env ]; then
        echo_error "\".env\" file not found\n"
        return 1
    fi

    if [ ! -f ./config/dynamic/dynamic.yaml ]; then
        echo_error "\"./config/dynamic/dynamic.yaml\" file not found\n"
        return 1
    fi

    echo_info "yq -i '.tls.certificates[0].certFile = \"/etc/traefik/certs/cert.pem\"' ./config/dynamic/dynamic.yaml\n"
    yq -i '.tls.certificates[0].certFile = "/etc/traefik/certs/cert.pem"' ./config/dynamic/dynamic.yaml

    echo_info "yq -i '.tls.certificates[0].keyFile = \"/etc/traefik/certs/key.pem\"' ./config/dynamic/dynamic.yaml\n"
    yq -i '.tls.certificates[0].keyFile = "/etc/traefik/certs/key.pem"' ./config/dynamic/dynamic.yaml

    # shellcheck disable=SC1090
    . "$(realpath .env)"

    _install=''
    for domain in ${DOMAINS}; do
        _install="${_install} ${domain}.localhost *.${domain}.localhost"
    done

    if [ ! -f ./certs/key.pem ] && [ ! -f ./certs/cert.pem ]; then
        echo_info "mkcert -key-file ./certs/key.pem -cert-file ./certs/cert.pem ${_install}\n"
        # shellcheck disable=SC2086
        mkcert -key-file ./certs/key.pem -cert-file ./certs/cert.pem ${_install}

        echo_info 'mkcert -install\n'
        mkcert -install
    fi
}

