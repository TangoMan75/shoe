#!/bin/sh

## {
##   "namespace": "recipes/traefik/docker",
##   "summary": "Start docker stack",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/docker/_docker_compose_start"
##   ]
## }
start() {
    _docker_compose_start ./compose.yaml || true
}

