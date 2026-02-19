#!/bin/sh

## Print Docker log
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "container_name"
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

