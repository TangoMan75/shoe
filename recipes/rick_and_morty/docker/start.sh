#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/docker",
##   "summary": "Start docker stack",
##   "depends": [
##     "src/shell/docker/_docker_compose_start"
##   ]
## }
start() {
    _docker_compose_start "./compose.${env}.yaml"
}

