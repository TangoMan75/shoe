#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Wait for rabbitmq container to start with docker",
##   "requires": [
##     "docker",
##     "grep"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning",
##     "src/shell/system/_check_installed",
##     "src/shell/system/_spin"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "CONTAINER_NAME",
##       "description": "The name of the docker container.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_wait_for_rabbit() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_wait_for_rabbit: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_wait_for_rabbit: too many arguments ($#)\n"; return 1; fi

    _echo_warning "Waiting for \"$1\" to start."

    while ! docker exec "$1" rabbitmqctl wait --pid 1 --timeout 1 2>/dev/null | grep -q "Applications 'rabbit_and_plugins' are running"; do
        _spin 600
    done

    _echo_success "\n\"$1\" is runnning.\n"
}

