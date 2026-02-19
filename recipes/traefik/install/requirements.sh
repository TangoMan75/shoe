#!/bin/sh

## Check requirements
##
## {
##   "namespace": "install",
##   "requires": [
##     "basename",
##     "command"
##   ],
##   "depends": [
##     "_echo_error"
##   ]
## }
requirements() {
    if [ ! -x "$(command -v docker)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker, try: 'sudo apt-get install -y docker.io'\n"
        _error=1
    fi

    if [ ! "$(docker compose >/dev/null 2>&1)" ] && [ ! -x "$(command -v docker-compose)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker-compose or docker compose plugin\n"
        _error=1
    fi

    if [ ! -x "$(command -v htpasswd)" ]; then
        _echo_error "\"$(basename "${0}")\" requires htpasswd, try 'sudo apt-get install -y apache2-utils'\n"
        _error=1
    fi

    if [ ! -x "$(command -v yq)" ]; then
        _echo_error "\"$(basename "${0}")\" requires yq\n"
        _error=1
    fi

    if [ "${env}" = dev ]; then
        if [ ! -x "$(command -v mkcert)" ]; then
            # brew install nss
            _echo_error "\"$(basename "${0}")\" requires mkcert, try: 'sudo apt-get install -y mkcert'\n"
            _error=1
        fi

        if [ ! -x "$(command -v certutil)" ]; then
            _echo_error "\"$(basename "${0}")\" requires certutil, try: 'sudo apt-get install -y libnss3-tools'\n"
            _error=1
        fi

        if [ ! -x "$(command -v yamllint)" ]; then
            _echo_error "\"$(basename "${0}")\" requires yamllint, try 'sudo apt-get install -y yamllint'\n"
            _error=1
        fi

        if [ ! -x "$(command -v shellcheck)" ]; then
            _echo_error "\"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'\n"
            _error=1
        fi
    fi

    return "${_error}"
}

