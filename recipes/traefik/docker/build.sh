#!/bin/sh

## Build docker stack
##
## {
##   "namespace": "docker",
##   "depends": [
##     "_docker_compose_build"
##   ]
## }
build() {
    _docker_compose_build ./compose.yaml
}

