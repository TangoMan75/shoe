#!/bin/sh

# Is container running
_is_running() {
    # Synopsys: _is_running [container_name]

    _check_installed docker

    if [ ${#} -lt 1 ]; then echo_danger 'error: _is_running: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _is_running: too many arguments (${#})\n"; return 1; fi

    if docker ps --quiet --format '{{.Names}}' 2>/dev/null | grep -E -q "^$1$"; then
        echo true
        return 0
    fi
    echo false
}

