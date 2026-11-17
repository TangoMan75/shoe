#!/bin/sh

## Backup all configuration
##
## @namespace recipes/ssh_manager/app
## @depends recipes/ssh_manager/backup/backup_gh_cli
## @depends recipes/ssh_manager/backup/backup_git_user
## @depends recipes/ssh_manager/backup/backup_gnome_dconf
## @depends recipes/ssh_manager/backup/backup_gpg
## @depends recipes/ssh_manager/backup/backup_gws
## @depends recipes/ssh_manager/backup/backup_opencode
## @depends recipes/ssh_manager/backup/backup_opencode_telegram_bot
## @depends recipes/ssh_manager/backup/backup_remmina
## @depends recipes/ssh_manager/backup/backup_ssh
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

