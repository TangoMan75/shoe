#!/bin/sh

## Remove ssh identities
remove_ssh_identities() {
    _alert_danger 'remove ssh identities'

    if ! _yes_no 'Are you sure you want to remove ssh identities?'; then
        _echo_warning 'operation canceled\n'

        return 1
    fi

    _echo_info 'ssh-add -D\n'
    ssh-add -D
}
