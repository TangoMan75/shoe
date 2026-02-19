#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/network",
##   "summary": "Remove /etc/hosts (local only)",
##   "depends": [
##     "src/shell/network/_remove_host"
##   ]
## }
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

