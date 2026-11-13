#!/bin/sh

## Stop docker stack
##
## @namespace recipes/calculatrice-salaire-net/docker
## @depends src/shell/docker/_docker_compose_stop
stop() {
    _docker_compose_stop
}

