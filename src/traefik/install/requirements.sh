#!/bin/sh

## Check requirements
requirements() {
    _error=0

    if ! _check_installed awk; then
        _error=1
    fi

    if ! _check_installed sed; then
        _error=1
    fi

    if ! _check_installed docker; then
        _error=1
    fi

    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        _error=1
    fi

    if ! _check_installed htpasswd; then
        _error=1
    fi

    if ! _check_installed yq; then
        _error=1
    fi

    if [ "${env}" = dev ]; then
        if ! _check_installed mkcert; then
            # brew install nss
            echo_error "optional: \"$(basename "${0}")\" requires mkcert, try: 'sudo apt-get install -y mkcert'\n"
            _error=1
        fi

        if ! _check_installed certutil; then
            _error=1
        fi

        if ! _check_installed yamllint; then
            _error=1
        fi

        if ! _check_installed shellcheck; then
            _error=1
        fi
    fi

    return "${_error}"
}

