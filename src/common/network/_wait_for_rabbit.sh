#!/bin/sh

# Wait for rabbitmq to start
_wait_for_rabbit() {
    # Synopsis: _wait_for_rabbit <CONTAINER_NAME>

    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    if [ ${#} -lt 1 ]; then echo_danger 'error: _wait_for_rabbit: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _wait_for_rabbit: too many arguments (${#})\n"; exit 1; fi

    echo_warning "Waiting for \"$1\" to start."
    while ! docker exec "$1" rabbitmqctl wait --pid 1 --timeout 1 2>/dev/null | grep -q "Applications 'rabbit_and_plugins' are running"; do
        echo_warning '.'
        sleep 1
    done
    echo_success "\n\"$1\" is runnning.\n"
}

