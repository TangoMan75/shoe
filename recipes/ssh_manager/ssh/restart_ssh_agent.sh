#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Restart ssh agent",
##   "requires": [
##     "service",
##     "sudo"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_is_gnome",
##     "src/shell/system/_is_termux"
##   ]
## }
restart_ssh_agent() {
    _alert_secondary 'restart ssh agent'

    if _is_gnome; then
        _echo_info 'sudo service sshd restart\n'
        sudo service sshd restart

        # echo_info 'sudo systemctl restart ssh.service\n'
        # sudo systemctl restart ssh.service
        return 0
    fi

    if _is_termux; then
        _echo_error 'termux terminal not supported\n'

        return 0
    fi

    _echo_error 'some unexpected error occured\n'
}
