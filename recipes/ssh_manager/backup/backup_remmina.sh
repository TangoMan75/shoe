#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup remmina",
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

    set -- "$(_create_backup_dir .config/remmina)" "$(_create_backup_dir .local/share/remmina)"

    _echo_info "cp -RfvT \"${HOME}/.config/remmina/\" \"$1\"\n"
    cp -RfvT "${HOME}/.config/remmina/" "$1"

    _echo_info "cp -RfvT \"${HOME}/.local/share/remmina/\" \"$2\"\n"
    cp -RfvT "${HOME}/.local/share/remmina/" "$2"
}

