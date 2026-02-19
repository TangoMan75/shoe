#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Stop container stack",
##   "requires": [
##     "basename",
##     "docker",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
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

