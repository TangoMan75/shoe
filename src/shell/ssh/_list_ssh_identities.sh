#!/bin/sh

## List the identities loaded in the ssh agent
##
## @namespace src/shell/ssh
## @requires command ssh-add
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_list_ssh_identities() {
    if [ $# -gt 0 ]; then _echo_error "_list_ssh_identities: too many arguments ($#)\n"; return 1; fi

    if ! command -v ssh-add >/dev/null 2>&1; then
        _echo_error '_list_ssh_identities: ssh-add required\n'

        return 1
    fi

    _echo_info 'ssh-add -l\n'
    ssh-add -l
}

