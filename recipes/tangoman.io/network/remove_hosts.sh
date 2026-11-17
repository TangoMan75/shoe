#!/bin/sh

## Remove /etc/hosts (local only)
##
## @namespace recipes/tangoman.io/network
## @depends src/shell/network/_remove_host
remove_hosts() {
    for _host_name in \
        dev.tangoman.io \
        dev.tangoman.localhost \
        tangoman.io \
        tangoman.localhost \
    ; do
        _remove_host "${_host_name}"
    done
}

