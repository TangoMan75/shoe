#!/bin/sh

## Start the agent and set the environment variables
start_ssh() {
    _alert_primary 'start ssh agent'

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
