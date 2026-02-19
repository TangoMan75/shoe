#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/docker",
##   "summary": "Start docker stack",
##   "depends": [
##     "src/shell/docker/_docker_compose_start"
##   ]
## }
start() {
    _docker_compose_start
}

