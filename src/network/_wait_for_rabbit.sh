#!/bin/sh

## Wait for rabbitmq to start
_wait_for_rabbit() {
    # Synopsys: _wait_for_rabbit [container_name]
    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing.\n'
        return 1
    fi
    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi
    echo_warning "Waiting for \"$1\" to start."
    while ! docker exec "$1" rabbitmqctl wait --pid 1 --timeout 1 2>/dev/null | grep -q "Applications 'rabbit_and_plugins' are running"; do
        echo_warning '.'
        sleep 1
    done
    echo_success "\n\"$1\" is runnning.\n"
}

