#!/bin/sh

## Config remmina
config_remmina() {
    _alert_secondary 'config remmina'

    if [ -d "${HOME}/.config/remmina" ]; then
        _echo_warning "\"${HOME}/.config/remmina\" folder already exists, config with remove it. This cannot be undone"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.config/remmina\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    if [ -d "${HOME}/.local/share/remmina" ]; then
        _echo_warning "\"${HOME}/.local/share/remmina\" folder already exists, config with remove it. This cannot be undone"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.local/share/remmina\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    set -- "$(_get_latest_backup_dir)/remmina/.config/remmina" "$(_get_latest_backup_dir)/remmina/.local/share/remmina"

    _echo_info "cp -RfvT \"$1\" \"${HOME}/.config/remmina\"\n"
    cp -RfvT "$1" "${HOME}/.config/remmina"

    _echo_info "cp -RfvT \"$2\" \"${HOME}/.local/share/remmina\"\n"
    cp -RfvT "$2" "${HOME}/.local/share/remmina"
}
