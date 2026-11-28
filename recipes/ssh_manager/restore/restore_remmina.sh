#!/bin/sh

## Restore remmina
##
## @namespace recipes/ssh_manager/restore
## @requires cp
## @depends recipes/ssh_manager/_get_latest_backup_dir.sh
## @depends src/shell/colors/_alert_secondary.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/prompts/_yes_no.sh
## @assumes HOME
restore_remmina() {
    _alert_secondary 'config remmina'

    if [ -d "${HOME}/.config/remmina" ]; then
        _echo_warning "\"${HOME}/.config/remmina\" folder already exists, config with remove it. This cannot be undone\n"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.config/remmina\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    if [ -d "${HOME}/.local/share/remmina" ]; then
        _echo_warning "\"${HOME}/.local/share/remmina\" folder already exists, config with remove it. This cannot be undone\n"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.local/share/remmina\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    set -- "$(_get_latest_backup_dir)/.config/remmina" "$(_get_latest_backup_dir)/.local/share/remmina"

    _echo_info "cp -RfvT \"$1\" \"${HOME}/.config/remmina\"\n"
    cp -RfvT "$1" "${HOME}/.config/remmina"

    _echo_info "cp -RfvT \"$2\" \"${HOME}/.local/share/remmina\"\n"
    cp -RfvT "$2" "${HOME}/.local/share/remmina"
}

