#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore ssh configuration",
##   "requires": [
##     "false",
##     "true"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_is_gcr_ssh_agent",
##     "recipes/ssh_manager/_start_gcr_ssh_agent",
##     "recipes/ssh_manager/ssh/config_known_ssh_hosts",
##     "recipes/ssh_manager/ssh/config_ssh_file_permissions",
##     "recipes/ssh_manager/ssh/restore_ssh_files",
##     "recipes/ssh_manager/ssh/ssh_add_all_identities",
##     "recipes/ssh_manager/ssh/start_ssh",
##     "recipes/ssh_manager/ssh/stop_ssh_agent",
##     "src/shell/colors/_alert_primary"
##   ]
## }
restore_ssh() {
    _alert_primary 'restore ssh'

    # gcr-ssh-agent watches ~/.ssh and crashes when its file tracker sees
    # modified or removed key files (notably when several .pub files share
    # the same public key). Stop it while ~/.ssh is being changed and start
    # it again afterwards.
    __gcr_ssh_agent_stopped__=false
    if _is_gcr_ssh_agent; then
        __gcr_ssh_agent_stopped__=true
        trap _start_gcr_ssh_agent EXIT HUP INT TERM
        stop_ssh_agent
    fi

    # Do not remove ~/.ssh before restoring: deleting the files while
    # gcr-ssh-agent is watching the folder crashes the agent and also
    # discards keys that are not present in the backup. Restore files in
    # place instead.
    restore_ssh_files
    config_ssh_file_permissions

    if [ "${__gcr_ssh_agent_stopped__}" = true ]; then
        _start_gcr_ssh_agent
    else
        start_ssh
    fi

    ssh_add_all_identities

    config_known_ssh_hosts
}

