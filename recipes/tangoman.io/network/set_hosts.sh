#!/bin/sh

## Set /etc/hosts (local only)
##
## @namespace recipes/tangoman.io/network
## @depends src/shell/network/_set_host
set_hosts() {
    for _host_name in \
        dev.tangoman.localhost \
        tangoman.localhost \
    ; do
        _set_host "${_host_name}"
    done
}

