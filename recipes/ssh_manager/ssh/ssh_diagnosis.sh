#!/bin/sh

## Diagnose ssh agent status
ssh_diagnosis() {
    _alert_primary 'ssh agent diagnosis'

    # 1. Check if an agent is running
    _echo_info "ps aux | grep '[s]sh-agent'\n"
    # shellcheck disable=SC2009
    ps aux | grep '[s]sh-agent'

    # 2. Check environment variables
    _echo_info "echo \"\$SSH_AUTH_SOCK\"\n"
    echo "$SSH_AUTH_SOCK"

    _echo_info "echo \"\$SSH_AGENT_PID\"\n"
    echo "$SSH_AGENT_PID"

    # 3. Check if the socket actually exists
    _echo_info "ls -l \"\$SSH_AUTH_SOCK\" 2>/dev/null || echo 'No socket'\n"
    ls -l "$SSH_AUTH_SOCK" 2>/dev/null || echo 'No socket'

    list_ssh_identities
}
