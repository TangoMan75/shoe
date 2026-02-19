#!/bin/sh

## Backup gnome dconf
backup_gnome_dconf() {
    _alert_primary 'backup gnome dconf'

    _check_installed dconf || return 0

    # check system uses gnome
    if ! _is_gnome; then
        _echo_warning "$(lsb_release -cs 2>/dev/null) not supported\n"

        return 0
    fi

    set -- "$(_create_backup_dir dconf)"

    _echo_info "dconf dump /org/gnome/ > \"$1/org_gnome.conf\"\n"
    dconf dump /org/gnome/ > "$1/org_gnome.conf"
}
