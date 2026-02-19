#!/bin/sh

## Build containers
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_docker_compose_build"
##   ]
## }
build() {
    _docker_compose_build "./compose.${env}.yaml"
}

