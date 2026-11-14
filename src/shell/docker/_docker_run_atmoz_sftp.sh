#!/bin/sh

## Run local atmoz_sftp server
##
## @namespace src/shell/docker
## @requires docker realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {str} <USERNAME> (required) The name of the container to run.
## @param {str} <PASSWORD> (required) The password for the sftp server access.
## @param {str} <NETWORK_MODE> /^(bridge|host)$/ The user name.
## @param {folder} <FOLDER_PATH> The path to the volume folder.
_docker_run_atmoz_sftp() {
    # note: atmoz_sftp documentation: https://github.com/atmoz/sftp

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_docker_run_atmoz_sftp: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_docker_run_atmoz_sftp: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "${3:-bridge}" "$4"

    if [ -z "$4" ]; then
        _echo_info "docker run --network \"${3:-bridge}\" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp \"$1:$2\"\n"
        docker run --network "${3:-bridge}" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp "$1:$2"

        return 0
    fi

    set -- "$1" "$2" "$3" "$(realpath "$4")"
    if [ ! -d "$4" ]; then _echo_error "_docker_run_atmoz_sftp: \"$4\" folder not found\n"; return 1; fi

    _echo_info "docker run --volume=\"$4:/home/shared\" --network \"${3:-bridge}\" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp \"$1:$2\"\n"
    docker run --volume="$4:/home/shared" --network "${3:-bridge}" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp "$1:$2"
}

