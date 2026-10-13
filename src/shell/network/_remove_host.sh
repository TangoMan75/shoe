#!/bin/sh

## {
##   "namespace": "src/shell/network",
##   "summary": "Remove hostname from /etc/hosts",
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_sed_i"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "HOSTNAME",
##       "type": "str",
##       "description": "The hostame to unset locally.",
##       "nullable": false
##     }
##   ]
## }
_remove_host() {
    # Synopsis: _remove_host <HOSTNAME>
    #   HOSTNAME: The hostame to unset locally.

    if [ -z "$1" ]; then _echo_error '_remove_host: some mandatory parameter is missing\n'; return 1; fi

    _echo_info "sudo $(_sed_i) \"/$1/d\" /etc/hosts\n"
    eval "sudo $(_sed_i) \"/$1/d\" /etc/hosts"
}
