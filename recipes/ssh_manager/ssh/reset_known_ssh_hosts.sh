#!/bin/sh

## Reset known_ssh_hosts
reset_known_ssh_hosts() {
    _alert_danger 'reset known_ssh_hosts'

    if ! _yes_no 'Are you sure you want to remove known_ssh_hosts?'; then
        _echo_warning 'operation canceled\n'

        return 1
    fi

    _echo_info "echo > \"${HOME}/.ssh/known_ssh_hosts\"\n"
    echo > "${HOME}/.ssh/known_ssh_hosts"
}
