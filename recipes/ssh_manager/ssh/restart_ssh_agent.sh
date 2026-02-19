#!/bin/sh

## Restart ssh agent
restart_ssh_agent() {
    _alert_primary 'restart ssh agent'

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
