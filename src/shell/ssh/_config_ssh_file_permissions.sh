#!/bin/sh

## Set the expected permissions on the ~/.ssh folder
##
## The folder is set to 700, private keys to 600 and public keys to 644.
## Configuration files such as authorized_keys, config and known_hosts are
## set to 644.
##
## @namespace src/shell/ssh
## @requires chmod chown find
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @assumes HOME USER
_config_ssh_file_permissions() {
    if [ "$#" -gt 0 ]; then _echo_error "_config_ssh_file_permissions: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "${HOME}/.ssh" ]; then
        _echo_error "_config_ssh_file_permissions: \"${HOME}/.ssh\" folder not found\n"

        return 1
    fi

    # correct ssh permissions
    _echo_info "chown \"${USER}\":\"${USER}\" -R \"${HOME}/.ssh\"\n"
    chown "${USER}:${USER}" -R "${HOME}/.ssh"

    # the .ssh directory should be 700 (drwx------)
    _echo_info "chmod 700 \"${HOME}/.ssh\"\n"
    chmod 700 "${HOME}/.ssh"

    # private keys should be 600 (-rw-------)
    # only apply this to regular files, never to directories or sockets
    _echo_info "find \"${HOME}/.ssh\" -maxdepth 1 -type f ! -name '*.pub' -exec chmod 600 {} +\n"
    find "${HOME}/.ssh" -maxdepth 1 -type f ! -name '*.pub' -exec chmod 600 {} +

    # public keys (.pub) should be 644 (-rw-r--r--)
    _echo_info "find \"${HOME}/.ssh\" -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +\n"
    find "${HOME}/.ssh" -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +

    # authorized_keys, config and known_hosts should be 644 as well
    set -- authorized_keys config known_hosts
    while [ "$#" -gt 0 ]; do
        if [ -f "${HOME}/.ssh/$1" ]; then
            _echo_info "chmod 644 \"${HOME}/.ssh/$1\"\n"
            chmod 644 "${HOME}/.ssh/$1"
        fi
        shift
    done
}

