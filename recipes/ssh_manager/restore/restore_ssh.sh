#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore ssh configuration",
##   "depends": [
##     "src/shell/colors/_alert_primary"
##   ]
## }
restore_ssh() {
    _alert_primary 'restore ssh'

    backup_ssh

    remove_ssh_identities
    remove_ssh_files

    restore_ssh_files
    config_ssh_file_permissions
    start_ssh
    ssh_add_all_identities

    config_known_ssh_hosts
}
