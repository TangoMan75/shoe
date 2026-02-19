#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup ssh",
##   "requires": [
##     "cp",
##     "find"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_create_backup_dir",
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

    # copy every entry, but skip sockets and other special files
    _echo_info "find \"${HOME}/.ssh\" -mindepth 1 -maxdepth 1 ! -type s -exec cp -Rfv {} \"$1\" \\;\n"
    find "${HOME}/.ssh" -mindepth 1 -maxdepth 1 ! -type s -exec cp -Rfv {} "$1" \;
}

