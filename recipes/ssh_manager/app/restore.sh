#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/app",
##   "summary": "Restore all configuration",
##   "depends": [
##     "recipes/ssh_manager/app/backup",
##     "recipes/ssh_manager/restore/restore_gh_cli",
##     "recipes/ssh_manager/restore/restore_git_user",
##     "recipes/ssh_manager/restore/restore_gnome_dconf",
##     "recipes/ssh_manager/restore/restore_gpg",
##     "recipes/ssh_manager/restore/restore_gws",
##     "recipes/ssh_manager/restore/restore_opencode",
##     "recipes/ssh_manager/restore/restore_opencode_telegram_bot",
##     "recipes/ssh_manager/restore/restore_remmina",
##     "recipes/ssh_manager/restore/restore_ssh"
##   ]
## }
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

