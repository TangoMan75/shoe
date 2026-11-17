#!/bin/sh

## Build docker stack
##
## @namespace recipes/traefik/docker
## @depends src/shell/docker/_docker_compose_build
build() {
    _docker_compose_build ./compose.yaml
}

