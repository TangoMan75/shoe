#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Restore ssh files",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning",
##     "src/shell/prompts/_yes_no"
##   ]
## }
restore_ssh_files() {
    _alert_secondary 'Restore ssh files'

    if [ -d "${HOME}/.ssh" ]; then
        _echo_warning "\"${HOME}/.ssh\" folder already exists, config with overwrite it. This cannot be undone\n"

        if ! _yes_no "Are you sure you want to overwrite \"${HOME}/.ssh\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    set -- "$(_get_latest_backup_dir)/.ssh"

    _echo_info "cp -Rfv \"$1\" \"${HOME}\"\n"
    cp -Rfv "$1" "${HOME}"
}
