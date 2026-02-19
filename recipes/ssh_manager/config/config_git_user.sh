#!/bin/sh

## Config git user
config_git_user() {
    _alert_secondary 'config git user'

    set -- "$(_get_latest_backup_dir)/git"

    _echo_info "sh \"$1/config_git_user.sh\"\n"
    sh "$1/config_git_user.sh"
}
