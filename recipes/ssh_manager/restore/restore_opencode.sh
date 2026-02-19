#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore opencode",
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
restore_opencode() {
    _alert_secondary 'config opencode'

    if [ -d "${HOME}/.config/opencode" ]; then
        _echo_warning "\"${HOME}/.config/opencode\" folder already exists, config with remove it. This cannot be undone\n"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.config/opencode\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    set -- "$(_get_latest_backup_dir)/.config/opencode"

    _echo_info "cp -RfvT \"$1\" \"${HOME}/.config/opencode\"\n"
    cp -RfvT "$1" "${HOME}/.config/opencode"
}

