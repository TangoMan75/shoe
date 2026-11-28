#!/bin/sh

## Build docker stack
##
## @namespace recipes/traefik/docker
## @depends src/shell/docker/_docker_compose_build.sh
build() {
    _docker_compose_build ./compose.yaml
}

