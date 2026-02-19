#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/app",
##   "summary": "Restore all configuration"
## }
restore() {
    backup_all

    restore_gh_cli
    restore_git_user
    restore_gnome_dconf
    restore_gws
    restore_opencode
    restore_opencode_telegram_bot
    restore_remina
    restore_ssh
}
