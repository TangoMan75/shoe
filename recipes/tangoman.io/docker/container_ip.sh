#!/bin/sh

## Get running container ip
##
## @namespace recipes/tangoman.io/docker
## @depends src/shell/docker/_get_container_ip
## @assumes container
## @option {str} <container> /^[a-zA-Z0-9_-]+$/ Container name.
# shellcheck disable=SC2154
container_ip() {
    _get_container_ip "${container}"
}

