#!/bin/sh

## Wait for postgresql container to start with docker
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/system/_check_installed.sh
## @depends src/shell/system/_spin.sh
## @param {str} <CONTAINER_NAME> (required) The name of the docker container.
## @param {str} <USERNAME> (default:"") The psql username.
_wait_for_postgres() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_wait_for_postgres: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_wait_for_postgres: too many arguments ($#)\n"; return 1; fi

    if [ -n "$2" ]; then
        set -- "$1" "$2"
    fi

    _echo_warning "Waiting for \"$1\" database to start."

    # Bound the wait: a wrong container name or a container that never
    # becomes ready must fail instead of spinning forever.
    __attempts__=0
    while :; do
        if [ -n "$2" ]; then
            if docker exec "$1" psql --username "$2" -l >/dev/null 2>&1; then
                break
            fi
        elif docker exec "$1" psql -l >/dev/null 2>&1; then
            break
        fi

        __attempts__=$((__attempts__ + 1))
        if [ "${__attempts__}" -ge 60 ]; then
            _echo_error "\n_wait_for_postgres: \"$1\" did not start in time\n"

            return 1
        fi

        _spin 600
    done

    _echo_success "\n\"$1\" is runnning.\n"
}

