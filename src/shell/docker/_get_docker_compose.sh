#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Return docker compose command",
##   "requires": [
##     "basename",
##     "command",
##     "docker",
##     "echo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ]
## }
_get_docker_compose() {
    # Synopsis: _get_docker_compose

    if [ "$(docker compose >/dev/null 2>&1)" ]; then
        echo 'docker compose'

        return 0
    fi

    if [ -x "$(command -v docker-compose)" ]; then
        echo 'docker-compose'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" requires docker-compose or docker compose plugin\n"

    exit 1
}

