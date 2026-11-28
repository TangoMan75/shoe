#!/bin/sh

## Build containers
##
## @namespace recipes/rick_and_morty/docker
## @depends src/shell/docker/_docker_compose_build.sh
## @assumes env
build() {
    _docker_compose_build "./compose.${env}.yaml"
}

