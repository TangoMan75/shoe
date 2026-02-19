#!/bin/sh

## Stop container stack
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ]
## }
stop() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _echo_info 'docker compose stop || true\n'
    docker compose stop || true
}

