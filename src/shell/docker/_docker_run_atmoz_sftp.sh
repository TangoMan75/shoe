#!/bin/sh

# Run local atmoz_sftp server
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
#       "name": "USERNAME",
#       "type": "str",
#       "description": "The name of the container to run.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "PASSWORD",
#       "type": "str",
#       "description": "The password for the sftp server access.",
#       "nullable": false
#     },
#     {
#       "position": 3,
#       "name": "NETWORK_MODE",
#       "type": "str",
#       "description": "The user name.",
#       "constraint": "/^(bridge|host)$/"
#     },
#     {
#       "position": 4,
#       "name": "FOLDER_PATH",
#       "type": "folder",
#       "description": "The path to the volume folder."
#     }
#   ]
# }
_docker_run_atmoz_sftp() {
    # Synopsis: _docker_run_atmoz_sftp <USERNAME> <PASSWORD> [NETWORK_MODE] [FOLDER_PATH]
    #   USERNAME:     The username for the sftp server access.
    #   PASSWORD:     The password for the sftp server access.
    #   NETWORK_MODE: (optional) Set network mode (bridge|host). Defaults to "bridge".
    #   FOLDER_PATH:  (optional) The path to the volume folder.
    #   note:         atmoz_sftp documentation: https://github.com/atmoz/sftp

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _docker_run_atmoz_sftp: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then echo_danger "error: _docker_run_atmoz_sftp: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "${3:-bridge}" "$4"

    if [ -z "$4" ]; then
        echo_info "docker run --network \"${3:-bridge}\" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp \"$1:$2\"\n"
        docker run --network "${3:-bridge}" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp "$1:$2"

        return 0
    fi

    set -- "$1" "$2" "$3" "$(realpath "$4")"
    if [ ! -d "$4" ]; then echo_danger "error: _docker_run_atmoz_sftp: \"$4\" folder not found\n"; return 1; fi

    echo_info "docker run --volume=\"$4:/home/shared\" --network \"${3:-bridge}\" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp \"$1:$2\"\n"
    docker run --volume="$4:/home/shared" --network "${3:-bridge}" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp "$1:$2"
}

