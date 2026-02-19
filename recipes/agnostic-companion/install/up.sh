#!/bin/sh

## {
##   "namespace": "recipes/agnostic-companion/install",
##   "summary": "Build and start container",
##   "depends": [
##     "recipes/agnostic-companion/docker/start",
##     "recipes/agnostic-companion/install/permissions",
##     "recipes/agnostic-companion/install/set_env",
##     "src/shell/colors/_alert_secondary"
##   ]
## }
up() {
    _alert_secondary "Starting ${ALIAS} container"
    permissions
    set_env
    start
}

