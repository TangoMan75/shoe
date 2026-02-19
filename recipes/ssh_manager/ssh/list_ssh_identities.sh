#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "List ssh identities",
##   "requires": [
##     "ssh-add"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info"
##   ]
## }
list_ssh_identities() {
    _alert_secondary 'list ssh identities'

    _echo_info 'ssh-add -l\n'
    ssh-add -l
}

