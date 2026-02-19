#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Restart containers",
##   "depends": [
##     "recipes/tangoman.io/docker/start",
##     "recipes/tangoman.io/docker/stop"
##   ]
## }
restart() {
    stop
    start
}

