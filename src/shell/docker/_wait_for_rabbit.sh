#!/bin/sh

## Wait for rabbitmq container to start with docker
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/system/_check_installed.sh
## @depends src/shell/system/_spin.sh
## @param {str} <CONTAINER_NAME> (required) The name of the docker container.
_wait_for_rabbit() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_wait_for_rabbit: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_wait_for_rabbit: too many arguments ($#)\n"; return 1; fi

    _echo_warning "Waiting for \"$1\" to start."

    # Bound the wait: a wrong container name or an image whose startup
    # never completes must fail instead of spinning forever.
    __attempts__=0
    until docker exec "$1" rabbitmqctl await_startup >/dev/null 2>&1; do
        __attempts__=$((__attempts__ + 1))
        if [ "${__attempts__}" -ge 60 ]; then
            _echo_error "\n_wait_for_rabbit: \"$1\" did not start in time\n"

            return 1
        fi

        _spin 600
    done

    _echo_success "\n\"$1\" is runnning.\n"
}

