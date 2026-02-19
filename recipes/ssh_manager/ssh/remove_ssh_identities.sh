#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Remove ssh identities",
##   "depends": [
##     "src/shell/colors/_alert_danger",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning",
##     "src/shell/prompts/_yes_no"
##   ]
## }
remove_ssh_identities() {
    _alert_danger 'remove ssh identities'

    if ! _yes_no 'Are you sure you want to remove ssh identities?'; then
        _echo_warning 'operation canceled\n'

        return 1
    fi

    _echo_info 'ssh-add -D\n'
    ssh-add -D
}
