#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore opencode-telegram-bot",
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
restore_opencode_telegram_bot() {
    _alert_secondary 'config opencode-telegram-bot'

    if [ -d "${HOME}/.config/opencode-telegram-bot" ]; then
        _echo_warning "\"${HOME}/.config/opencode-telegram-bot\" folder already exists, config with remove it. This cannot be undone\n"
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.config/opencode-telegram-bot\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    set -- "$(_get_latest_backup_dir)/.config/opencode-telegram-bot"

    _echo_info "cp -RfvT \"$1\" \"${HOME}/.config/opencode-telegram-bot\"\n"
    cp -RfvT "$1" "${HOME}/.config/opencode-telegram-bot"
}
