#!/bin/sh

## {
##   "namespace": "recipes/traefik/docker",
##   "summary": "Build docker stack",
##   "depends": [
##     "src/shell/docker/_docker_compose_build"
##   ]
## }
build() {
    _docker_compose_build ./compose.yaml
}

