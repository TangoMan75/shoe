#!/bin/sh

## Remove symlink
remove_symlink() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _container_project_directory=/var/www

    echo_info "rm -f \"${_container_project_directory}\"\n"
    rm -f "${_container_project_directory}"
}

