#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Remove ssh files",
##   "requires": [
##     "mkdir",
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_danger",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning",
##     "src/shell/prompts/_yes_no"
##   ]
## }
remove_ssh_files() {
    _alert_danger 'remove ssh files'

    if [ -d "${HOME}/.ssh" ]; then
        if ! _yes_no "Are you sure you want to remove \"${HOME}/.ssh\" folder?"; then
            _echo_warning 'operation canceled\n'

            return 1
        fi
    fi

    _echo_info "rm -rf \"${HOME}/.ssh\"\n"
    rm -rf "${HOME}/.ssh"

    _echo_info "mkdir -p \"${HOME}/.ssh\"\n"
    mkdir -p "${HOME}/.ssh"
}

