#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore gh-cli",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_get_latest_backup_dir",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning",
##     "src/shell/prompts/_yes_no"
##   ]
## }
restore_gh_cli() {
    _alert_secondary 'config gh-cli'

    if [ -d "${HOME}/.config/gh" ]; then
        _echo_warning "\"${HOME}/.config/gh\" folder already exists, config with remove it. This cannot be undone\n"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.config/gh\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    set -- "$(_get_latest_backup_dir)/.config/gh"

    _echo_info "cp -RfvT \"$1\" \"${HOME}/.config/gh\"\n"
    cp -RfvT "$1" "${HOME}/.config/gh"
}

