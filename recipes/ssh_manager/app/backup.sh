#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/app",
##   "summary": "Backup all configuration"
## }
backup() {
    backup_gh_cli
    backup_git_user
    backup_gnome_dconf
    backup_gpg
    backup_gws
    backup_opencode
    backup_opencode_telegram_bot
    backup_remmina
    backup_ssh
}
