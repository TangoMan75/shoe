#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup gh-cli",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
##   ]
## }
backup_gh_cli() {
    _alert_primary 'backup gh-cli'

    if [ ! -d "${HOME}/.config/gh" ]; then
        _echo_warning "error: ${HOME}/.config/gh/ folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir .config/gh)"

    _echo_info "cp -RfvT \"${HOME}/.config/gh/\" \"$1\"\n"
    cp -RfvT "${HOME}/.config/gh/" "$1"
}
