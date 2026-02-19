#!/bin/sh

## Remove symlink
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_is_root"
##   ]
## }
remove_symlink() {
    if ! _is_root; then
        _echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _container_project_directory=/var/www

    _echo_info "rm -f \"${_container_project_directory}\"\n"
    rm -f "${_container_project_directory}"
}

