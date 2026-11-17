#!/bin/sh

## Restore all configuration
##
## @namespace recipes/ssh_manager/app
## @depends recipes/ssh_manager/app/backup
## @depends recipes/ssh_manager/restore/restore_gh_cli
## @depends recipes/ssh_manager/restore/restore_git_user
## @depends recipes/ssh_manager/restore/restore_gnome_dconf
## @depends recipes/ssh_manager/restore/restore_gpg
## @depends recipes/ssh_manager/restore/restore_gws
## @depends recipes/ssh_manager/restore/restore_opencode
## @depends recipes/ssh_manager/restore/restore_opencode_telegram_bot
## @depends recipes/ssh_manager/restore/restore_remmina
## @depends recipes/ssh_manager/restore/restore_ssh
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

