#!/bin/sh

# Execute command in the given docker container
#
# {
#   "namespace": "docker",
#   "requires": [
#     "docker"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "CONTAINER_NAME",
#       "type": "str",
#       "description": "The name of the container to run.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "COMMAND",
#       "type": "str",
#       "description": "The command to execute.",
#       "nullable": false
#     },
#     {
#       "position": 3,
#       "name": "USER",
#       "type": "str",
#       "description": "The user name."
#     }
#   ]
# }
_docker_exec() {
    # Synopsis: _docker_exec <CONTAINER_NAME> <COMMAND> [USER]
    #   CONTAINER_NAME: The name of the container to run.
    #   COMMAND:        The command to execute.
    #   USER:           (optional) The user name.

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _docker_exec: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then echo_danger "error: _docker_exec: too many arguments ($#)\n"; return 1; fi

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

