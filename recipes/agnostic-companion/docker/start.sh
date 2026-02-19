#!/bin/sh

## {
##   "namespace": "recipes/agnostic-companion/docker",
##   "summary": "Start docker stack",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/docker/_docker_compose_start"
##   ]
## }
start() {
    if [ -f .env ]; then
        _docker_compose_start ./compose.yaml ./.env || true
        return 0
    fi

    _docker_compose_start ./compose.yaml || true
}

