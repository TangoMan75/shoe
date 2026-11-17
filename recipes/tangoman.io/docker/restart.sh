#!/bin/sh

## Restart containers
##
## @namespace recipes/tangoman.io/docker
## @depends recipes/tangoman.io/docker/start
## @depends recipes/tangoman.io/docker/stop
restart() {
    stop
    start
}

