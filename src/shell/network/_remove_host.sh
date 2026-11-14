#!/bin/sh

## Remove hostname from /etc/hosts
##
## @namespace src/shell/network
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_sed_i
## @param {str} <HOSTNAME> (required) The hostame to unset locally.
_remove_host() {
    if [ -z "$1" ]; then _echo_error '_remove_host: some mandatory parameter is missing\n'; return 1; fi

    _echo_info "sudo $(_sed_i) \"/$1/d\" /etc/hosts\n"
    eval "sudo $(_sed_i) \"/$1/d\" /etc/hosts"
}

