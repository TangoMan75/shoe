#!/bin/sh

## Execute command in the given docker container
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME> (required) The name of the container to run.
## @param {str} <COMMAND> (required) The command to execute.
## @param {str} <USER> The user name.
_docker_exec() {
    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_docker_exec: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_docker_exec: too many arguments ($#)\n"; return 1; fi

    if [ -z "$3" ]; then
        _echo_info "docker exec --interactive --tty \"$1\" $2\n"
        # shellcheck disable=SC2086
        docker exec --interactive --tty "$1" $2

        return 0
    fi

    _echo_info "docker exec --interactive --tty --user \"$3\" \"$1\" $2\n"
    # shellcheck disable=SC2086
    docker exec --interactive --tty --user "$3" "$1" $2
}

