#!/bin/sh

## Start docker stack
##
## @namespace recipes/rick_and_morty/docker
## @depends src/shell/docker/_docker_compose_start
## @assumes env
start() {
    _docker_compose_start "./compose.${env}.yaml"
}

