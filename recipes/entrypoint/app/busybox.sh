#!/bin/sh

## Run tests in Busybox Docker container
##
## The Busybox image ships without a package manager. Bash, Python,
## ShellCheck and the GNU utilities required by the test suite are
## installed once in a cached Alpine toolbox volume, then exposed to
## the Busybox container.
##
## @namespace recipes/entrypoint/app
## @requires docker sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
## @depends src/shell/system/_pwd.sh
busybox() {
    _check_installed docker

    toolbox_volume='shoe-entrypoint-toolbox'

    # BusyBox has no package manager, so it builds a cached Alpine toolbox volume (shoe-entrypoint-toolbox)
    # containing Bash/Python/ShellCheck/GNU tools, then runs the BusyBox image's own shell and applets.
    _echo_info "docker run --rm --volume=\"${toolbox_volume}:/tools\" alpine sh -c 'apk add --root /tools ...'\n"
    docker run --rm --volume="${toolbox_volume}:/tools" alpine sh -c '
        [ -f /tools/.shoe-toolbox ] && exit 0
        mkdir -p /tools/etc/apk &&
        cp -r /etc/apk/keys /tools/etc/apk/ &&
        cp /etc/apk/repositories /tools/etc/apk/repositories &&
        apk add --no-cache --root /tools --initdb \
            bash coreutils gawk git grep openssl python3 sed \
            shellcheck util-linux-misc &&
        touch /tools/.shoe-toolbox'

    # `${PATH}` and `${LD_LIBRARY_PATH}` are expanded in the container.
    # shellcheck disable=SC2016
    docker_command='ln -sf /tools/lib/ld-musl-*.so.1 /lib/ &&
        ln -sf /tools/bin/bash /bin/bash &&
        mkdir -p /usr/libexec /usr/share &&
        ln -sf /tools/usr/libexec/git-core /usr/libexec/git-core &&
        ln -sf /tools/usr/share/git-core /usr/share/git-core &&
        export PATH="/tools/usr/bin:/tools/bin:${PATH}" &&
        export LD_LIBRARY_PATH="/tools/lib:/tools/usr/lib" &&
        sh entrypoint.sh tests'

    _echo_info "docker run --rm --volume=\"${toolbox_volume}:/tools\" --volume=\"$(_pwd):/home:ro\" --workdir=\"/home\" busybox sh -c \"${docker_command}\"\n"
    docker run --rm --volume="${toolbox_volume}:/tools" --volume="$(_pwd):/home:ro" --workdir="/home" busybox sh -c "${docker_command}"
}

