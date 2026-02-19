#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Print Docker log",
##   "requires": [
##     "basename",
##     "docker"
##   ],
##   "depends": [
##     "recipes/tangoman.io/docker/container_name",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
docker_logs() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _echo_info "docker compose logs -f \"$(container_name)\"\n"
    docker compose logs -f "$(container_name)"
}

