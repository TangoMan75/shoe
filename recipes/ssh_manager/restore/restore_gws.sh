#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore gws",
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
restore_gws() {
    _alert_secondary 'config gws'

    if [ -d "${HOME}/.config/gws" ]; then
        _echo_warning "\"${HOME}/.config/gws\" folder already exists, config with remove it. This cannot be undone\n"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.config/gws\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    set -- "$(_get_latest_backup_dir)/.config/gws"

    _echo_info "cp -RfvT \"$1\" \"${HOME}/.config/gws\"\n"
    cp -RfvT "$1" "${HOME}/.config/gws"
}
