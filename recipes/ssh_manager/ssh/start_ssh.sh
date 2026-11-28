#!/bin/sh

## Start the agent and set the environment variables
##
## @namespace recipes/ssh_manager/ssh
## @requires export mkdir ssh-agent
## @depends recipes/ssh_manager/_is_ssh_agent_running.sh
## @depends src/shell/colors/_alert_secondary.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/compatibility/_is_gnome.sh
## @depends src/shell/compatibility/_is_termux.sh
## @assumes HOME
start_ssh() {
    _alert_secondary 'start ssh agent'

    if _is_termux && ! _is_gnome; then
        _echo_info 'mkdir -p ~/.ssh-agent\n'
        mkdir -p ~/.ssh-agent

        if _is_ssh_agent_running "${HOME}/.ssh-agent/socket"; then
            _echo_info 'ssh agent already running\n'
            export SSH_AUTH_SOCK="${HOME}/.ssh-agent/socket"

            return 0
        fi

        _echo_info "eval \"\$(ssh-agent -s -a ~/.ssh-agent/socket)\"\n"
        eval "$(ssh-agent -s -a ~/.ssh-agent/socket)"

        return 0
    fi

    if _is_ssh_agent_running; then
        _echo_info 'ssh agent already running\n'

        return 0
    fi

    _echo_info "eval \"\$(ssh-agent -s)\"\n"
    eval "$(ssh-agent -s)"
}

