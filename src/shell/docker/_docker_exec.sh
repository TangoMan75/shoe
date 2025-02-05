#!/bin/sh

# Execute command in the given docker container
_docker_exec() {
    # Synopsis: _docker_exec <CONTAINER_NAME> <COMMAND> [USER]
    #   CONTAINER_NAME: The name of the container to run.
    #   COMMAND:        The command to execute.
    #   USER:           (optional) The user name.

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _docker_exec: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _docker_exec: too many arguments (${#})\n"; return 1; fi

    if [ -z "$3" ]; then
        echo_info "docker exec --interactive --tty \"$1\" $2\n"
        # shellcheck disable=SC2086
        docker exec --interactive --tty "$1" $2

        return 0
    fi

    echo_info "docker exec --interactive --tty --user \"$3\" \"$1\" $2\n"
    # shellcheck disable=SC2086
    docker exec --interactive --tty --user "$3" "$1" $2
}

