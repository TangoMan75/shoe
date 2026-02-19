#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup gpg",
##   "requires": [
##     "cp",
##     "find"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
##   ]
## }
backup_gpg() {
    _alert_primary 'backup gpg'

    if [ ! -d "${HOME}/.gnupg" ]; then
        _echo_warning "error: \"${HOME}/.gnupg/\" folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir .gnupg)"

    _echo_info "cp -RfvT \"${HOME}/.gnupg/\" \"$1\"\n"
    cp -RfvT "${HOME}/.gnupg/" "$1"

    find "$1" -type s -delete
}
