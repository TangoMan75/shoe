#!/bin/sh

## Add every ssh identity found in ~/.ssh to the ssh agent
##
## Each public key ending with ".pub" must have a matching private key in
## the same folder.
##
## @namespace src/shell/ssh
## @requires command find printf sed ssh-add
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_warning
## @assumes HOME
_ssh_add_all_identities() {
    if [ "$#" -gt 0 ]; then _echo_error "_ssh_add_all_identities: too many arguments ($#)\n"; return 1; fi

    if ! command -v ssh-add >/dev/null 2>&1; then
        _echo_error '_ssh_add_all_identities: ssh-add required\n'

        return 1
    fi

    if [ -z "${HOME}" ]; then
        _echo_error '_ssh_add_all_identities: HOME is not set\n'

        return 1
    fi

    if [ ! -d "${HOME}/.ssh" ]; then
        _echo_error "_ssh_add_all_identities: \"${HOME}/.ssh\" folder not found\n"

        return 1
    fi

    # $1: newline separated list of public keys left to process.
    set -- "$(find "${HOME}/.ssh" -type f -name '*.pub')"
    while [ -n "$1" ]; do
        # $2: public key path, $3: matching private key path.
        set -- "$1" "$(printf '%s\n' "$1" | sed -n '1p')"
        set -- "$1" "$2" "${2%.pub}"

        if [ ! -f "$3" ]; then
            _echo_warning "error: \"$3\" private key not found\n"
        else
            _echo_info "ssh-add \"$3\"\n"
            ssh-add "$3"
        fi

        # drop the processed public key from the list
        set -- "$(printf '%s\n' "$1" | sed -e '1d')"
    done
}

