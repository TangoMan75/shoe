#!/bin/sh

## Start docker stack
##
## @namespace recipes/traefik/docker
## @requires true
## @depends src/shell/docker/_docker_compose_start
start() {
    _docker_compose_start ./compose.yaml || true
}

