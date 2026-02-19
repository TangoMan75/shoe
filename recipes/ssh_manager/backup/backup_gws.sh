#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup gws",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_create_backup_dir",
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
##   ]
## }
backup_gws() {
    _alert_primary 'backup gws'

    if [ ! -d "${HOME}/.config/gws" ]; then
        _echo_warning "error: ${HOME}/.config/gws/ folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir .config/gws)"

    _echo_info "cp -RfvT \"${HOME}/.config/gws/\" \"$1\"\n"
    cp -RfvT "${HOME}/.config/gws/" "$1"
}

