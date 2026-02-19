#!/bin/sh

## Config ssh
config_ssh() {
    _alert_primary 'config ssh'

    restore_ssh_files
    config_ssh_file_permissions
    start_ssh
    ssh_add_all_identities
}
