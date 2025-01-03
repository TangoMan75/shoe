#!/bin/sh

# Run local atmoz_sftp server with "host" network
_docker_atmoz_sftp() {
    # Synopsis: _docker_atmoz_sftp <USERNAME> <PASSWORD> [HOST]
    #   USERNAME:  The username for the sftp server access.
    #   PASSWORD:  The password for the sftp server access.
    #   HOST:      (optional) Enable host network mode. Defaults to "false".
    #   note:      atmoz_sftp documentation: https://github.com/atmoz/sftp

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _docker_atmoz_sftp: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _docker_atmoz_sftp: too many arguments (${#})\n"; return 1; fi

    echo_info 'docker kill atmoz_sftp || true\n'
    docker kill atmoz_sftp || true

    echo_info 'docker rm atmoz_sftp || true\n'
    docker rm atmoz_sftp || true

    if [ "${3:-false}" = true ]; then
        echo_info "docker run --network host --name atmoz_sftp -d atmoz/sftp \"$1:$2\"\n"
        docker run --network host --name atmoz_sftp -d atmoz/sftp "$1:$2"

        return 0
    fi

    echo_info "docker run --name atmoz_sftp -p 22:22 -d atmoz/sftp \"$1:$2\"\n"
    docker run --name atmoz_sftp -p 22:22 -d atmoz/sftp "$1:$2"
}

