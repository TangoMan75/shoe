#!/bin/sh

## Backup remmina
backup_remmina() {
    _alert_primary 'backup remmina'

    if [ ! -d "${HOME}/.config/remmina" ]; then
        _echo_warning "error: ${HOME}/.config/remmina/ folder not found\n"

        return 0
    fi

    if [ ! -d "${HOME}/.local/share/remmina" ]; then
        _echo_warning "error: ${HOME}/.local/share/remmina/ folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir remmina/.config/remmina)" "$(_create_backup_dir remmina/.local/share/remmina)"

    _echo_info "cp -RfvT \"${HOME}/.config/remmina/\" \"$1\"\n"
    cp -RfvT "${HOME}/.config/remmina/" "$1"

    _echo_info "cp -RfvT \"${HOME}/.local/share/remmina/\" \"$2\"\n"
    cp -RfvT "${HOME}/.local/share/remmina/" "$2"
}
