#!/bin/sh

## Wait for postgresql container to start with docker
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_success src/shell/colors/_echo_warning src/shell/system/_check_installed src/shell/system/_spin
## @param {str} <CONTAINER_NAME> (required) The name of the docker container.
## @param {str} <USERNAME> (default:"") The psql username.
_wait_for_postgres() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_wait_for_postgres: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_wait_for_postgres: too many arguments ($#)\n"; return 1; fi

    if [ -n "$2" ]; then
        set -- "$1" "--username $2"
    fi

    _echo_warning "Waiting for \"$1\" database to start."

    while [ ! "$(docker exec "$1" psql "$2" -l 2>/dev/null)" ]; do
        _spin 600
    done

    _echo_success "\n\"$1\" is runnning.\n"
}

