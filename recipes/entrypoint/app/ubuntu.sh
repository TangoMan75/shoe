#!/bin/sh

## Run tests in Ubuntu Docker container
##
## @namespace recipes/entrypoint/app
## @requires docker sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
## @depends src/shell/system/_pwd.sh
ubuntu() {
    _check_installed docker

    docker_command='export DEBIAN_FRONTEND=noninteractive &&
        apt-get update &&
        apt-get install -y --no-install-recommends \
            bash bsdextrautils gawk git openssl python3 shellcheck &&
        sh entrypoint.sh tests'

    _echo_info "docker run --rm --volume=\"$(_pwd):/home:ro\" --workdir=\"/home\" ubuntu sh -c \"${docker_command}\"\n"
    docker run --rm --volume="$(_pwd):/home:ro" --workdir="/home" ubuntu sh -c "${docker_command}"
}

