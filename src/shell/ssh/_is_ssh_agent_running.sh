#!/bin/sh

## Check if an ssh agent is running
##
## The socket advertised through SSH_AUTH_SOCK is used by default. ssh-add
## exits 0 when identities are loaded and 1 when the agent is reachable but
## has no identities. Exit status 2 means no agent is reachable.
##
## @namespace src/shell/ssh
## @requires ssh-add
## @depends src/shell/colors/_echo_error.sh
## @assumes SSH_AUTH_SOCK
## @param {str} <SOCKET> (default:"$SSH_AUTH_SOCK") The ssh agent socket path.
_is_ssh_agent_running() {
    if [ "$#" -gt 1 ]; then _echo_error "_is_ssh_agent_running: too many arguments ($#)\n"; return 1; fi

    set -- "${1:-${SSH_AUTH_SOCK}}"

    # `-S`: returns true when the path exists and is a Unix domain socket
    if [ -z "$1" ] || [ ! -S "$1" ]; then

        return 1
    fi

    SSH_AUTH_SOCK="$1" ssh-add -l >/dev/null 2>&1
    set -- "$1" "$?"

    # 0: identities loaded, 1: agent reachable without identities
    if [ "$2" -eq 0 ] || [ "$2" -eq 1 ]; then
        return 0
    fi

    return 1
}

