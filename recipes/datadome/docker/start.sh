#!/bin/sh

## {
##   "namespace": "recipes/datadome/docker",
##   "summary": "Start docker stack",
##   "depends": [
##     "src/shell/docker/_docker_compose_start"
##   ]
## }
start() {
    _docker_compose_start
}

