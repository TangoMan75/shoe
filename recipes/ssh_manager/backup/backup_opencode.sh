#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup opencode",
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
backup_opencode() {
    _alert_primary 'backup opencode'

    if [ ! -d "${HOME}/.config/opencode" ]; then
        _echo_warning "error: ${HOME}/.config/opencode/ folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir .config/opencode)"

    _echo_info "cp -RfvT \"${HOME}/.config/opencode/\" \"$1\"\n"
    cp -RfvT "${HOME}/.config/opencode/" "$1"
}

