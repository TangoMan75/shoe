#!/bin/sh

## {
##   "namespace": "recipes/agnostic-companion/docker",
##   "summary": "Stop docker stack",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/docker/_docker_compose_stop"
##   ]
## }
stop() {
    _docker_compose_stop ./compose.yaml || true
}

