#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Remove ssh identities",
##   "requires": [
##     "ssh-add"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_is_ssh_agent_running",
##     "src/shell/colors/_alert_danger",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning",
##     "src/shell/prompts/_yes_no"
##   ]
## }
remove_ssh_identities() {
    _alert_danger 'remove ssh identities'

    if ! _is_ssh_agent_running; then
        _echo_warning 'no ssh agent running, nothing to remove\n'

        return 0
    fi

    if ! _yes_no 'Are you sure you want to remove ssh identities?'; then
        _echo_warning 'operation canceled\n'

        return 1
    fi

    _echo_info 'ssh-add -D\n'
    ssh-add -D
}

