#!/bin/sh

## Restore gnome dconf
##
## @namespace recipes/ssh_manager/restore
## @requires dconf lsb_release
## @depends recipes/ssh_manager/_get_latest_backup_dir.sh
## @depends src/shell/colors/_alert_secondary.sh
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/compatibility/_is_gnome.sh
## @depends src/shell/system/_check_installed.sh
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

