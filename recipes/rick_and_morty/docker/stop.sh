#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/docker",
##   "summary": "Stop docker stack",
##   "depends": [
##     "src/shell/docker/_docker_compose_stop"
##   ]
## }
stop() {
    _docker_compose_stop "./compose.${env}.yaml"
}

