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
    _error=0

    if [ ! -x "$(command -v docker)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker, try: 'sudo apt-get install -y docker.io'\n"
        _error=1
    fi

    if [ ! "$(docker compose >/dev/null 2>&1)" ] && [ ! -x "$(command -v docker-compose)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker-compose or docker compose plugin\n"
        _error=1
    fi

    return "${_error}"
}

