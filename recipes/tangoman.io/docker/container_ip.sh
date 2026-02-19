#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Get running container ip",
##   "depends": [
##     "src/shell/docker/_get_container_ip"
##   ]
## }
container_ip() {
    _get_container_ip "${container}"
}

