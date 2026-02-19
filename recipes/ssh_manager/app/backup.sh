#!/bin/sh

## Backup ssh keys, git user, gnome conf and remmina
backup() {
    backup_git_user
    backup_gnome_dconf
    backup_remmina
    backup_ssh
}
