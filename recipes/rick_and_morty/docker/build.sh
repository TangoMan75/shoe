#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/docker",
##   "summary": "Build containers",
##   "depends": [
##     "src/shell/docker/_docker_compose_build"
##   ]
## }
build() {
    _docker_compose_build "./compose.${env}.yaml"
}

