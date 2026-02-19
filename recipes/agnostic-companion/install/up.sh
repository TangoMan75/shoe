#!/bin/sh

## Build and start container
##
## {
##   "namespace": "install",
##   "depends": [
##     "_alert_secondary",
##     "permissions",
##     "set_env",
##     "start"
##   ]
## }
up() {
    _alert_secondary "Starting ${ALIAS} container"
    permissions
    set_env
    start
}

