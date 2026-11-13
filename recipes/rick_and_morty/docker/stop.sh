#!/bin/sh

## Stop docker stack
##
## @namespace recipes/rick_and_morty/docker
## @depends src/shell/docker/_docker_compose_stop
## @assumes env
stop() {
    _docker_compose_stop "./compose.${env}.yaml"
}

