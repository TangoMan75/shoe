#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Run local atmoz_sftp server",
##   "requires": [
##     "docker",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "USERNAME",
##       "description": "The name of the container to run.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "PASSWORD",
##       "description": "The password for the sftp server access.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 3,
##       "name": "NETWORK_MODE",
##       "description": "The user name.",
##       "type": "str",
##       "constraint": "/^(bridge|host)$/"
##     },
##     {
##       "position": 4,
##       "name": "FOLDER_PATH",
##       "description": "The path to the volume folder.",
##       "type": "folder"
##     }
##   ]
## }
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

