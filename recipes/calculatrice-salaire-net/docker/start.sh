#!/bin/sh

## Start docker stack
##
## @namespace recipes/calculatrice-salaire-net/docker
## @depends src/shell/docker/_docker_compose_start
start() {
    _docker_compose_start
}

