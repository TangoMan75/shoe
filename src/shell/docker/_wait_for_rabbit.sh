#!/bin/sh

# Wait for rabbitmq container to start with docker
_wait_for_rabbit() {
    # Synopsis: _wait_for_rabbit <CONTAINER_NAME>
    #   CONTAINER_NAME: The name of the rabbitmq docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _wait_for_rabbit: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _wait_for_rabbit: too many arguments (${#})\n"; return 1; fi

    echo_warning "Waiting for \"$1\" to start."

    while ! docker exec "$1" rabbitmqctl wait --pid 1 --timeout 1 2>/dev/null | grep -q "Applications 'rabbit_and_plugins' are running"; do
        _spin 600
    done

    echo_success "\n\"$1\" is runnning.\n"
}

