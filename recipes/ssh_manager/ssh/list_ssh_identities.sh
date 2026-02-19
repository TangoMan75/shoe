#!/bin/sh

## List ssh identities
list_ssh_identities() {
    _alert_primary 'list ssh identities'

    _echo_info 'ssh-add -l\n'
    ssh-add -l
}
