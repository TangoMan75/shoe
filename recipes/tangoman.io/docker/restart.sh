#!/bin/sh

## Restart containers
##
## @namespace recipes/tangoman.io/docker
## @depends recipes/tangoman.io/docker/start.sh
## @depends recipes/tangoman.io/docker/stop.sh
restart() {
    stop
    start
}

