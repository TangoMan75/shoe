#!/bin/sh

## Start docker stack
##
## @namespace recipes/datadome/docker
## @depends src/shell/docker/_docker_compose_start
start() {
    _docker_compose_start
}

