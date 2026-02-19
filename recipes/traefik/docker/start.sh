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
    _docker_compose_start ./compose.yaml || true
}

