#!/bin/sh

## Get running container ip
##
## @namespace recipes/tangoman.io/docker
## @depends src/shell/docker/_get_container_ip
## @assumes container
container_ip() {
    _get_container_ip "${container}"
}

