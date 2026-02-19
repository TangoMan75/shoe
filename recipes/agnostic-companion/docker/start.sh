#!/bin/sh

## Start docker stack
##
## {
##   "namespace": "docker",
##   "depends": [
##     "_docker_compose_start"
##   ]
## }
start() {
    if [ -f .env ]; then
        _docker_compose_start ./compose.yaml ./.env || true
        return 0
    fi

    _docker_compose_start ./compose.yaml || true
}

