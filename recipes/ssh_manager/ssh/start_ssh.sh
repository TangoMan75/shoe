#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Start the agent and set the environment variables",
##   "requires": [
##     "mkdir"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_is_gnome",
##     "src/shell/system/_is_termux"
##   ]
## }
start_ssh() {
    _alert_secondary 'start ssh agent'

    if _is_termux && ! _is_gnome; then
        _echo_info 'mkdir -p ~/.ssh-agent\n'
        mkdir -p ~/.ssh-agent

        _echo_info "eval \"$(ssh-agent -s -a ~/.ssh-agent/socket)\"\n"
        eval "$(ssh-agent -s -a ~/.ssh-agent/socket)"

        return 0
    fi

    _echo_info "eval \"$(ssh-agent -s)\"\n"
    eval "$(ssh-agent -s)"
}
