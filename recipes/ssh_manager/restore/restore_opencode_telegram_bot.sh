#!/bin/sh

## Restore opencode-telegram-bot
##
## @namespace recipes/ssh_manager/restore
## @requires cp
## @depends recipes/ssh_manager/_get_latest_backup_dir.sh
## @depends src/shell/colors/_alert_secondary.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/prompts/_yes_no.sh
## @assumes HOME
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

