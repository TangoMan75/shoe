#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/restore",
##   "summary": "Restore git user config",
##   "requires": [
##     "sh"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info"
##   ]
## }
restore_git_user() {
    _alert_secondary 'config git user'

    set -- "$(_get_latest_backup_dir)/git"

    _echo_info "sh \"$1/config_git_user.sh\"\n"
    sh "$1/config_git_user.sh"
}
