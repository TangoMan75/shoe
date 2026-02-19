#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore gws",
##   "requires": [
##     "chmod",
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

    _echo_warning 'config gws file permissions'

    if [ ! -d "${HOME}/.config/gws" ]; then

        return 0
    fi

    # the gws directory should be 700 (drwx-----)
    _echo_info "chmod 700 \"${HOME}/.config/gws\"\n"
    chmod 700 "${HOME}/.config/gws"

    # restore copies files with the default umask, which leaves them group
    # and world readable (gws then warns about the encryption key mode);
    # the encryption key, encrypted credentials, oauth client secret and
    # token cache should be 600 (-rw-------)
    for __file__ in .encryption_key client_secret.json credentials.enc token_cache.json; do
        if [ -f "${HOME}/.config/gws/${__file__}" ]; then
            _echo_info "chmod 600 \"${HOME}/.config/gws/${__file__}\"\n"
            chmod 600 "${HOME}/.config/gws/${__file__}"
        fi
    done
}

