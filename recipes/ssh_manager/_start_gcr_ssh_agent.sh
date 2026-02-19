#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager",
##   "summary": "Start gcr-ssh-agent after it was stopped for a restore",
##   "requires": [
##     "false",
##     "systemctl",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
_start_gcr_ssh_agent() {
    if [ "${__gcr_ssh_agent_stopped__:-false}" != true ]; then

        return 0
    fi

    __gcr_ssh_agent_stopped__=false
    trap - EXIT HUP INT TERM

    _echo_info 'systemctl --user start gcr-ssh-agent.socket gcr-ssh-agent.service\n'
    systemctl --user start gcr-ssh-agent.socket gcr-ssh-agent.service || true
}

