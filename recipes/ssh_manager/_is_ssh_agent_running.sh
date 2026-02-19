#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager",
##   "summary": "Check if ssh agent is running",
##   "requires": [
##     "ssh-add"
##   ],
##   "assumes": [
##     "SSH_AUTH_SOCK"
##   ]
## }
_is_ssh_agent_running() {
    # default to the socket advertised through the environment
    set -- "${1:-${SSH_AUTH_SOCK}}"

    # `-S`: A file test operator that returns true if the specified path exists and is a Unix domain socket
    if [ -z "$1" ] || [ ! -S "$1" ]; then
        return 1
    fi

    # ssh-add -l exits 0 when identities are loaded and 1 when the agent is
    # running but has no identities. Exit status 2 means no agent is reachable.
    __status__=0
    SSH_AUTH_SOCK="$1" ssh-add -l >/dev/null 2>&1 || __status__=$?

    case "${__status__}" in
        0|1) return 0 ;;
        *) return 1 ;;
    esac
}

