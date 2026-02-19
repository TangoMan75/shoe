#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager",
##   "summary": "Check if the current ssh agent is gcr-ssh-agent",
##   "assumes": [
##     "SSH_AUTH_SOCK"
##   ]
## }
_is_gcr_ssh_agent() {
    # gcr-ssh-agent is usually exposed as ${XDG_RUNTIME_DIR}/gcr/ssh
    case "${SSH_AUTH_SOCK}" in
        */gcr/ssh) return 0 ;;
    esac

    return 1
}

