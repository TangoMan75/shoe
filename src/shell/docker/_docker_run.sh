#!/bin/sh

## Spawn a new container with given image, name, command and volume
##
## @namespace src/shell/docker
## @requires docker realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {str} <IMAGE> (required) The name of the container image to run.
## @param {str} <NAME> (required) Assign a name to the container.
## @param {str} <COMMAND> (required) The command to run inside provided container.
## @param {folder} <FOLDER_PATH> The path to the volume folder.
_docker_run() {
    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_docker_run: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_docker_run: too many arguments ($#)\n"; return 1; fi

    if [ -z "$4" ]; then
        _echo_info "docker run --detach --rm --interactive --tty --name \"$2\" \"$1\" $3\n"
        # shellcheck disable=SC2086
        docker run --detach --rm --interactive --tty --name "$2" "$1" $3

        return 0
    fi

    set -- "$1" "$2" "$3" "$(realpath "$4")"
    if [ ! -d "$4" ]; then _echo_error "_docker_run: \"$3\" folder not found\n"; return 1; fi

    _echo_info "docker run --detach --rm --interactive --tty --volume=\"$4:/home\" --workdir=\"/home\" --name \"$2\" \"$1\" $3\n"
    # shellcheck disable=SC2086
    docker run --detach --rm --interactive --tty --volume="$4:/home" --workdir="/home" --name "$2" "$1" $3
}

