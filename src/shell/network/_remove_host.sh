#!/bin/sh

# Remove hostname from /etc/hosts
_remove_host() {
    # Synopsis: remove_host <HOSTNAME>
    #   HOSTNAME: The hostame to unset locally.

    if [ -z "$1" ]; then echo_danger 'error: _remove_host: some mandatory parameter is missing\n'; return 1; fi

    echo_info "sudo $(_sed_i) \"/$1/d\" /etc/hosts\n"
    eval "sudo $(_sed_i) \"/$1/d\" /etc/hosts"
}

