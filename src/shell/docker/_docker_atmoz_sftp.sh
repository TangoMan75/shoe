#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# Run local atmoz_sftp server with "host" network
_docker_atmoz_sftp() {
    # Synopsis: _docker_atmoz_sftp <USERNAME> <PASSWORD>
    #   USERNAME:  The username for the sftp server access.
    #   PASSWORD:  The password for the sftp server access.
    #   note:      atmoz_sftp documentation: https://github.com/atmoz/sftp

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _docker_psql: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _docker_psql: too many arguments (${#})\n"; return 1; fi

    echo_info 'docker kill atmoz_sftp || true\n'
    docker kill atmoz_sftp || true

    echo_info 'docker rm atmoz_sftp || true\n'
    docker rm atmoz_sftp || true

    echo_info "docker run --network host --name atmoz_sftp -p 22:22 -d atmoz/sftp \"$1:$2\"\n"
    docker run --network host --name atmoz_sftp -p 22:22 -d atmoz/sftp "$1:$2"
}

