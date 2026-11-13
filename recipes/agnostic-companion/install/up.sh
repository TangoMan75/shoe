#!/bin/sh

## Build and start container
##
## @namespace recipes/agnostic-companion/install
## @depends recipes/agnostic-companion/docker/start recipes/agnostic-companion/install/permissions recipes/agnostic-companion/install/set_env src/shell/colors/_alert_secondary
## @assumes ALIAS
up() {
    _alert_secondary "Starting ${ALIAS} container"
    permissions
    set_env
    start
}

