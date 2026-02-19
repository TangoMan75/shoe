#!/bin/sh

## Backup ssh
backup_ssh() {
    _alert_primary 'backup ssh'

    if [ ! -d "${HOME}/.ssh" ]; then
        _echo_warning "error: \"${HOME}/.ssh/\" folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir .ssh)"

    _echo_info "cp -RfvT \"${HOME}/.ssh/\" \"$1\"\n"
    cp -RfvT "${HOME}/.ssh/" "$1"
}
