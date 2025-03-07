#!/bin/sh

# Spawn a new container with given image, name, command and volume
_docker_run() {
    # Synopsis: _docker_run <IMAGE> <NAME> <COMMAND> [FOLDER_PATH]
    #   IMAGE:       The name of the container image to run.
    #   NAME:        Assign a name to the container.
    #   COMMAND:     The command to run inside provided container.
    #   FOLDER_PATH: (optional) The path to the volume folder.

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then echo_danger 'error: _docker_run: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 4 ]; then echo_danger "error: _docker_run: too many arguments (${#})\n"; return 1; fi

    if [ -z "$4" ]; then
        echo_info "docker run --detach --rm --interactive --tty --name \"$2\" \"$1\" $3\n"
        # shellcheck disable=SC2086
        docker run --detach --rm --interactive --tty --name "$2" "$1" $3

        return 0
    fi

    set -- "$1" "$2" "$3" "$(realpath "$4")"
    if [ ! -d "$4" ]; then echo_danger "error: _docker_run: \"$3\" folder not found\n"; return 1; fi

    echo_info "docker run --detach --rm --interactive --tty --volume=\"$4:/home\" --workdir=\"/home\" --name \"$2\" \"$1\" $3\n"
    # shellcheck disable=SC2086
    docker run --detach --rm --interactive --tty --volume="$4:/home" --workdir="/home" --name "$2" "$1" $3
}

