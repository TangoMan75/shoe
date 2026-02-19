#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Restart ssh agent",
##   "requires": [
##     "service",
##     "sudo",
##     "systemctl"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_is_gcr_ssh_agent",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_is_gnome",
##     "src/shell/system/_is_termux"
##   ]
## }
restart_ssh_agent() {
    _alert_secondary 'restart ssh agent'

    if _is_gcr_ssh_agent; then
        _echo_info 'systemctl --user start gcr-ssh-agent.socket\n'
        systemctl --user start gcr-ssh-agent.socket

        _echo_info 'systemctl --user restart gcr-ssh-agent.service\n'
        systemctl --user restart gcr-ssh-agent.service

        return 0
    fi

    if _is_gnome; then
        # On Debian/Ubuntu the service is called "ssh", not "sshd"
        _echo_info 'sudo systemctl restart ssh.service\n'
        sudo systemctl restart ssh.service

        return 0
    fi

    if _is_termux; then
        _echo_error 'termux terminal not supported\n'

        return 0
    fi

    _echo_error 'some unexpected error occured\n'
}

