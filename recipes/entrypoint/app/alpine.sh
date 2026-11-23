#!/bin/sh

## Run tests in Alpine Docker container
##
## @namespace recipes/entrypoint/app
## @requires docker sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
## @depends src/shell/system/_pwd.sh
alpine() {
    _check_installed docker

    docker_command='apk add --no-cache \
            bash coreutils gawk git grep openssl python3 shellcheck \
            util-linux-misc &&
        sh entrypoint.sh tests'

    _echo_info "docker run --rm --volume=\"$(_pwd):/home:ro\" --workdir=\"/home\" alpine sh -c \"${docker_command}\"\n"
    docker run --rm --volume="$(_pwd):/home:ro" --workdir="/home" alpine sh -c "${docker_command}"
}

