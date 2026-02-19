#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Stop ssh agent",
##   "requires": [
##     "systemctl"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_is_gcr_ssh_agent",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info"
##   ]
## }
stop_ssh_agent() {
    _alert_secondary 'stop ssh agent'

    if _is_gcr_ssh_agent; then
        _echo_info 'systemctl --user stop gcr-ssh-agent.socket gcr-ssh-agent.service\n'
        systemctl --user stop gcr-ssh-agent.socket gcr-ssh-agent.service

        return 0
    fi

    return 1
}

