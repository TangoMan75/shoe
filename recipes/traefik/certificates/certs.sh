#!/bin/sh

## {
##   "namespace": "recipes/traefik/certificates",
##   "summary": "Install local SSL certificates",
##   "requires": [
##     "mkcert",
##     "yq"
##   ],
##   "depends": [
##     "recipes/traefik/certificates/print_domains",
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/reflexion/_get_parameter",
##     "src/shell/system/_check_installed"
##   ]
## }
certs() {
    _check_installed mkcert
    _check_installed yq

    if [ "${env}" = prod ]; then
        _echo_error 'This command should not be executed in production environement!\n'

        return 0
    fi

    if [ ! -f ./config/dynamic/dynamic.yaml ]; then
        _echo_danger "error: \"./config/dynamic/dynamic.yaml\" file not found\n"
        return 1
    fi

    _echo_info "yq -i '.tls.certificates[0].certFile = \"/etc/traefik/certs/cert.pem\"' ./config/dynamic/dynamic.yaml\n"
    yq -i '.tls.certificates[0].certFile = "/etc/traefik/certs/cert.pem"' ./config/dynamic/dynamic.yaml

    _echo_info "yq -i '.tls.certificates[0].keyFile = \"/etc/traefik/certs/key.pem\"' ./config/dynamic/dynamic.yaml\n"
    yq -i '.tls.certificates[0].keyFile = "/etc/traefik/certs/key.pem"' ./config/dynamic/dynamic.yaml

    DOMAINS="$(_get_parameter .env DOMAINS)"
    _install=''
    for _domain in ${DOMAINS}; do
        _install="${_install} ${_domain}.localhost *.${_domain}.localhost"
    done

    _echo_info "mkcert -key-file ./certs/key.pem -cert-file ./certs/cert.pem ${_install}\n"
    # shellcheck disable=SC2086
    mkcert -key-file ./certs/key.pem -cert-file ./certs/cert.pem ${_install}

    _echo_info 'mkcert -install\n'
    mkcert -install

    print_domains
}

