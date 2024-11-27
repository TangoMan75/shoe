#!/bin/sh

## Wait for postgresql to start
_wait_for_postgres() {
    # Synopsys: _wait_for_postgres [container_name] (username)
    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing.\n'
        return 1
    fi
    if [ ${#} -gt 2 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi
    if [ -n "$2" ]; then
        set -- "$1" "--username $2"
    fi
    echo_warning "Waiting for \"$1\" database to start."
    while [ ! "$(docker exec "$1" psql "$2" -l 2>/dev/null)" ]; do
        echo_warning '.'
        sleep 1
    done
    echo_success "\n\"$1\" is runnning.\n"
}
