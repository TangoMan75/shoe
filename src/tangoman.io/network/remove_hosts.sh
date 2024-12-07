#!/bin/sh

## Remove /etc/hosts (local only)
remove_hosts() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    for _host_name in \
        dev.tangoman.io \
        dev.tangoman.localhost \
        tangoman.io \
        tangoman.localhost \
    ; do
        _remove_hosts "${_host_name}"
    done
}

