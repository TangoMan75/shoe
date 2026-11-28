#!/bin/sh

## Restore all configuration
##
## @namespace recipes/ssh_manager/app
## @depends recipes/ssh_manager/app/backup.sh
## @depends recipes/ssh_manager/restore/restore_gh_cli.sh
## @depends recipes/ssh_manager/restore/restore_git_user.sh
## @depends recipes/ssh_manager/restore/restore_gnome_dconf.sh
## @depends recipes/ssh_manager/restore/restore_gpg.sh
## @depends recipes/ssh_manager/restore/restore_gws.sh
## @depends recipes/ssh_manager/restore/restore_opencode.sh
## @depends recipes/ssh_manager/restore/restore_opencode_telegram_bot.sh
## @depends recipes/ssh_manager/restore/restore_remmina.sh
## @depends recipes/ssh_manager/restore/restore_ssh.sh
restore() {
    backup

    restore_gh_cli
    restore_git_user
    restore_gnome_dconf
    restore_gpg
    restore_gws
    restore_opencode
    restore_opencode_telegram_bot
    restore_remmina
    restore_ssh
}

