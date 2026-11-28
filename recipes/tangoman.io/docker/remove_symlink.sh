#!/bin/sh

## Remove symlink
##
## @namespace recipes/tangoman.io/docker
## @requires rm
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_is_root.sh
## @assumes USER
remove_symlink() {
    if ! _is_root; then
        _echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _container_project_directory=/var/www

    _echo_info "rm -f \"${_container_project_directory}\"\n"
    rm -f "${_container_project_directory}"
}

