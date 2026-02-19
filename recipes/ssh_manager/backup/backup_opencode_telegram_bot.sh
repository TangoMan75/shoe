#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup opencode-telegram-bot",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
##   ]
## }
backup_opencode_telegram_bot() {
    _alert_primary 'backup opencode-telegram-bot'

    if [ ! -d "${HOME}/.config/opencode-telegram-bot" ]; then
        _echo_warning "error: ${HOME}/.config/opencode-telegram-bot/ folder not found\n"

        return 0
    fi

    set -- "$(_create_backup_dir .config/opencode-telegram-bot)"

    _echo_info "cp -RfvT \"${HOME}/.config/opencode-telegram-bot/\" \"$1\"\n"
    cp -RfvT "${HOME}/.config/opencode-telegram-bot/" "$1"
}
