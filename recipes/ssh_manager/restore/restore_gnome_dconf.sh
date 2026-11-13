#!/bin/sh

## Restore gnome dconf
##
## @namespace recipes/ssh_manager/restore
## @requires dconf lsb_release
## @depends recipes/ssh_manager/_get_latest_backup_dir src/shell/colors/_alert_secondary src/shell/colors/_echo_danger src/shell/colors/_echo_info src/shell/compatibility/_is_gnome src/shell/system/_check_installed
restore_gnome_dconf() {
    _alert_secondary 'config gnome dconf'

    _check_installed dconf

    # check system uses gnome
    if ! _is_gnome; then
        _echo_danger "error: $(lsb_release -cs 2>/dev/null) not supported\n"

        return 1
    fi

    set -- "$(_get_latest_backup_dir)/dconf"

    _echo_info "dconf load /org/gnome/ < \"$1/org_gnome.conf\"\n"
    dconf load /org/gnome/ < "$1/org_gnome.conf"
}

