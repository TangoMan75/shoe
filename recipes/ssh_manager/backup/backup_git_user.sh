#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/backup",
##   "summary": "Backup git user",
##   "requires": [
##     "chmod",
##     "git",
##     "tee"
##   ],
##   "depends": [
##     "recipes/ssh_manager/_create_backup_dir",
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
backup_git_user() {
    _alert_primary 'backup git user'

    _check_installed git || return 0

    set -- "$(_create_backup_dir git)"

    tee > "$1/config_git_user.sh"<<EOL
#!/bin/sh

# restore git user
# ----------------

git config --replace-all --global user.name "$(git config --get user.name)"
git config --replace-all --global user.email "$(git config --get user.email)"

echo 'Restored git user:'
git config --global --get user.name
git config --global --get user.email
EOL

    _echo_info "chmod a+x \"$1/config_git_user.sh\"\n"
    chmod a+x "$1/config_git_user.sh"
}

