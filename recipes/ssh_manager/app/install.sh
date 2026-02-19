#!/bin/sh

## Config ssh, git and gnome
install() {
    backup
    uninstall
    config_known_ssh_hosts
    config_ssh
    config_ssh_file_permissions
    config_git_user
    config_gnome_dconf
}
