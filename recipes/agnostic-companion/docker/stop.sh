#!/bin/sh

## Stop docker stack
##
## @namespace recipes/agnostic-companion/docker
## @requires true
## @depends src/shell/docker/_docker_compose_stop
stop() {
    _docker_compose_stop ./compose.yaml || true
}

