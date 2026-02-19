#!/bin/sh

## Stop docker stack
##
## {
##   "namespace": "docker",
##   "depends": [
##     "_docker_compose_stop"
##   ]
## }
stop() {
    _docker_compose_stop
}

