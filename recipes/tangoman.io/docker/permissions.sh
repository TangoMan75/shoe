#!/bin/sh

## Set correct permissions
##
## @namespace recipes/tangoman.io/docker
## @depends recipes/tangoman.io/development/_get_httpduser recipes/tangoman.io/docker/_permissions src/shell/colors/_echo_error src/shell/system/_is_root
## @assumes USER
permissions() {
    if ! _is_root; then
        _echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _httpduser=$(_get_httpduser)

    for _directory in \
        ./assets \
        ./bin \
        ./certs \
        ./logs \
        ./var \
        ./vendor \
        ./volumes \
    ; do
        _permissions "${_httpduser}" "${_directory}"
    done
}

