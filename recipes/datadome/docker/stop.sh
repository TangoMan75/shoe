#!/bin/sh

## Stop docker stack
##
## @namespace recipes/datadome/docker
## @depends src/shell/docker/_docker_compose_stop
stop() {
    _docker_compose_stop
}

