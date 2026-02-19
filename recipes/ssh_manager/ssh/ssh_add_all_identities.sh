#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "ssh-add all identities present in ssh folder",
##   "requires": [
##     "find",
##     "ssh-add"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
##   ]
## }
ssh_add_all_identities() {
    _alert_secondary 'ssh-add all identities'

    set -- "${HOME}/.ssh"

    find "$1" -type f -name '*.pub' | while read -r file_path; do
        # remove ".pub" from filename to get the matching private key
        identity="${file_path%.pub}"

        if [ ! -f "${identity}" ]; then
            _echo_warning "error: \"${identity}\" private key not found\n"

            continue
        fi

        _echo_info "ssh-add \"${identity}\"\n"
        ssh-add "${identity}"
    done
}

