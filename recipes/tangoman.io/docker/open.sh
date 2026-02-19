#!/bin/sh

## Open container in default browser
##
## {
##   "namespace": "docker",
##   "depends": [
##     "_echo_error",
##     "_find_container_name",
##     "_open_in_default_browser"
##   ]
## }
open() {
    _container_name="$(_find_container_name nginx)"
    if [ -z "${_container_name}" ]; then
        _echo_error 'nginx container not found\n'

        return 1
    fi

    _container_ip="$(_get_container_ip "${_container_name}")"
    if [ -z "${_container_ip}" ]; then
        _echo_error 'container ip not found\n'

        return 1
    fi

    _open_in_default_browser "${_container_ip}"
}

