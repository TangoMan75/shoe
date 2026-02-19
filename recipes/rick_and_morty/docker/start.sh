#!/bin/sh

## Start docker stack
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_docker_compose_start"
##   ]
## }
start() {
    _docker_compose_start "./compose.${env}.yaml"
}

