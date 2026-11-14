#!/bin/sh

## Set new host in /etc/hosts
##
## @namespace src/shell/network
## @requires sudo
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/network/_remove_host
## @param {str} <HOSTNAME> (required) The hostame to set locally.
_set_host() {
    if [ -z "$1" ]; then _echo_error '_set_host: some mandatory parameter is missing\n'; return 1; fi

    _remove_host "$1"

    _echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}

