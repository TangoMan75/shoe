#!/bin/sh

## Remove ssh
remove_ssh() {
    _alert_danger 'remove ssh'

    if [ -d "${HOME}/.ssh" ]; then
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.ssh\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    _echo_info "rm -rf \"${HOME}/.ssh\"\n"
    rm -rf "${HOME}/.ssh"

    _echo_info "mkdir -p \"${HOME}/.ssh\"\n"
    mkdir -p "${HOME}/.ssh"
}
