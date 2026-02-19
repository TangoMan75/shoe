#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/network",
##   "summary": "Set /etc/hosts (local only)",
##   "depends": [
##     "src/shell/network/_set_host"
##   ]
## }
set_hosts() {
    for _host_name in \
        dev.tangoman.localhost \
        tangoman.localhost \
    ; do
        _set_host "${_host_name}"
    done
}

