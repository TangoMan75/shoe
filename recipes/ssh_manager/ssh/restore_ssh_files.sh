#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Restore ssh files",
##   "requires": [
##     "cp",
##     "mkdir"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_get_latest_backup_dir",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
##   ]
## }
restore_ssh_files() {
    _alert_secondary 'Restore ssh files'

    set -- "$(_get_latest_backup_dir)/.ssh"

    if [ ! -d "$1" ]; then
        _echo_warning "error: \"$1\" folder not found\n"

        return 0
    fi

    _echo_info "mkdir -p \"${HOME}/.ssh\"\n"
    mkdir -p "${HOME}/.ssh"

    # Merge the backup into ~/.ssh instead of replacing the folder. This
    # keeps unrelated files (known_hosts, extra keys, sockets, ...) and
    # avoids triggering the gcr-ssh-agent file tracker crash.
    _echo_info "cp -RfvT \"$1\" \"${HOME}/.ssh\"\n"
    cp -RfvT "$1" "${HOME}/.ssh"
}

