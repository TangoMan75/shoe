#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup ssh",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
##   ]
## }
backup_ssh() {
    _alert_primary 'backup ssh'

    if [ ! -d "${HOME}/.ssh" ]; then
        _echo_warning "error: \"${HOME}/.ssh/\" folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir .ssh)"

    _echo_info "cp -fv \"${HOME}/.ssh/authorized_keys\" \"$1\"\n"
    cp -fv "${HOME}/.ssh/authorized_keys" "$1"

    _echo_info "cp -fv \"${HOME}/.ssh/config\" \"$1\"\n"
    cp -fv "${HOME}/.ssh/config" "$1"

    _echo_info "cp -fv \"${HOME}\"/.ssh/id_rsa* \"$1\"\n"
    cp -fv "${HOME}"/.ssh/id_rsa* "$1"
}
