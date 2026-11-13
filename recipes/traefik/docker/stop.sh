#!/bin/sh

## Stop docker stack
##
## @namespace recipes/traefik/docker
## @requires true
## @depends src/shell/docker/_docker_compose_stop
stop() {
    _docker_compose_stop ./compose.yaml || true
}

