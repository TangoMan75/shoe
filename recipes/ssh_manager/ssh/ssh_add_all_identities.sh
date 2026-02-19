#!/bin/sh

## ssh-add all identities present in ssh folder
ssh_add_all_identities() {
    _alert_secondary 'ssh-add all identities'

    set -- "${HOME}/.ssh"

    find "$1" -type f -name '*.pub' | while read -r file_path; do
        # remove (temporarily) ".pub" from filename
        identity="$(basename "${file_path}" .pub)"

        _echo_info "ssh-add \"$1/${identity}\"\n"
        ssh-add "$1/${identity}"
    done
}
