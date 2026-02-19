#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/app",
##   "summary": "Backup all configuration",
##   "depends": [
##     "recipes/ssh_manager/backup/backup_gh_cli",
##     "recipes/ssh_manager/backup/backup_git_user",
##     "recipes/ssh_manager/backup/backup_gnome_dconf",
##     "recipes/ssh_manager/backup/backup_gpg",
##     "recipes/ssh_manager/backup/backup_gws",
##     "recipes/ssh_manager/backup/backup_opencode",
##     "recipes/ssh_manager/backup/backup_opencode_telegram_bot",
##     "recipes/ssh_manager/backup/backup_remmina",
##     "recipes/ssh_manager/backup/backup_ssh"
##   ]
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

