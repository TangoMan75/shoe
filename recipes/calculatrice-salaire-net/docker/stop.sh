#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/docker",
##   "summary": "Stop docker stack",
##   "depends": [
##     "src/shell/docker/_docker_compose_stop"
##   ]
## }
stop() {
    _docker_compose_stop
}

