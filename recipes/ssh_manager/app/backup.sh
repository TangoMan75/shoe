#!/bin/sh

## Backup all configuration
##
## @namespace recipes/ssh_manager/app
## @depends recipes/ssh_manager/backup/backup_gh_cli.sh
## @depends recipes/ssh_manager/backup/backup_git_user.sh
## @depends recipes/ssh_manager/backup/backup_gnome_dconf.sh
## @depends recipes/ssh_manager/backup/backup_gpg.sh
## @depends recipes/ssh_manager/backup/backup_gws.sh
## @depends recipes/ssh_manager/backup/backup_opencode.sh
## @depends recipes/ssh_manager/backup/backup_opencode_telegram_bot.sh
## @depends recipes/ssh_manager/backup/backup_remmina.sh
## @depends recipes/ssh_manager/backup/backup_ssh.sh
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

