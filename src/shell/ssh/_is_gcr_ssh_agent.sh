#!/bin/sh

## Check if the current ssh agent is gcr-ssh-agent
##
## gcr-ssh-agent is usually exposed as ${XDG_RUNTIME_DIR}/gcr/ssh.
##
## @namespace src/shell/ssh
## @assumes SSH_AUTH_SOCK
_is_gcr_ssh_agent() {
    if [ "${SSH_AUTH_SOCK%*/gcr/ssh}" != "${SSH_AUTH_SOCK}" ]; then
        return 0
    fi

    return 1
}

