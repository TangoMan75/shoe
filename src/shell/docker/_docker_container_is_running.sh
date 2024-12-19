#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# Is container running
_docker_container_is_running() {
    # Synopsis: _is_running <CONTAINER_NAME>
    #   CONTAINER_NAME:  The name of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _docker_container_is_running: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _docker_container_is_running: too many arguments (${#})\n"; return 1; fi

    if docker ps --format '{{.Names}}' 2>/dev/null | grep -E -q "^$1$"; then

        return 0
    fi

    return 1
}

