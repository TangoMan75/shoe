#!/bin/sh

## Set correct permissions
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_get_httpduser",
##     "_is_root",
##     "_permissions"
##   ]
## }
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
        ./node_modules \
        ./var \
        ./vendor \
        ./volumes \
    ; do
        _permissions "${_httpduser}" "${_directory}"
    done
}

