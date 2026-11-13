#!/bin/sh

## Create symlink to match container project directory structure
##
## @namespace recipes/tangoman.io/docker
## @requires ln pwd
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_is_root
## @assumes USER
symlink() {
    if ! _is_root; then
        _echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _host_project_directory="$(pwd)"
    _container_project_directory=/var/www

    _echo_info "ln -s \"${_host_project_directory}\" \"${_container_project_directory}\"\n"
    ln -s "${_host_project_directory}" "${_container_project_directory}"
}

