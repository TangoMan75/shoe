#!/bin/bash

## Shortcut for apt-get remove -y
##
## @namespace recipes/bash_aliases/system
## @requires apt-get sudo
## @depends src/shell/colors/_echo_danger src/shell/colors/_echo_info
## @param {str} <package> (required) Package name to remove.
function pkg-remove() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "sudo apt-get remove -y \"$1\"\n"
    # shellcheck disable=SC2033
    sudo apt-get remove -y "$1"
}

