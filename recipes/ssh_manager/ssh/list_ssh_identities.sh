#!/bin/sh

## List ssh identities
##
## @namespace recipes/ssh_manager/ssh
## @requires ssh-add
## @depends src/shell/colors/_alert_secondary.sh
## @depends src/shell/colors/_echo_info.sh
list_ssh_identities() {
    _alert_secondary 'list ssh identities'

    _echo_info 'ssh-add -l\n'
    ssh-add -l
}

