#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore gpg",
##   "requires": [
##     "chmod",
##     "cp",
##     "gpg-agent",
##     "gpgconf"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_get_latest_backup_dir",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning",
##     "src/shell/prompts/_yes_no",
##     "src/shell/system/_is_installed"
##   ]
## }
restore_gpg() {
    _alert_secondary 'config gpg'

    set -- "$(_get_latest_backup_dir)/.gnupg"

    if [ ! -d "$1" ]; then
        _echo_warning "error: \"$1\" folder not found\n"

        return 0
    fi

    if [ -d "${HOME}/.gnupg" ]; then
        _echo_warning "\"${HOME}/.gnupg\" folder already exists, config with remove it. This cannot be undone\n"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.gnupg\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    _echo_info "cp -RfvT \"$1\" \"${HOME}/.gnupg\"\n"
    cp -RfvT "$1" "${HOME}/.gnupg"

    _echo_info "chmod 700 \"${HOME}/.gnupg\"\n"
    chmod 700 "${HOME}/.gnupg"

    if _is_installed gpgconf; then
        _echo_info 'gpgconf --kill gpg-agent\n'
        gpgconf --kill gpg-agent
    fi
}

