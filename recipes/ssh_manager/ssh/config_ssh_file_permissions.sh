#!/bin/sh

## Config ssh file permissions
config_ssh_file_permissions() {
    _alert_primary 'config ssh file permissions'

    # correct ssh permissions
    _echo_info "chown \"${USER}\":\"${USER}\" -R \"${HOME}/.ssh\"\n"
    chown "${USER}":"${USER}" -R "${HOME}/.ssh"

    # the .ssh directory should be 700 (drwx----)
    _echo_info "chmod 700 \"${HOME}/.ssh\"\n"
    chmod 700 "${HOME}/.ssh"

    # the private keys should be 600 (-rw-------)
    _echo_info "chmod 600 ${HOME}/.ssh/*\n"
    # shellcheck disable=SC2086
    chmod 600 ${HOME}/.ssh/*

    # the public keys (.pub) should be 644 (-rw-------)
    _echo_info "chmod 644 ${HOME}/.ssh/*.pub\n"
    # shellcheck disable=SC2086
    chmod 644 ${HOME}/.ssh/*.pub

    # authorized_keys should be 644 as well
    _echo_info "chmod 644 \"${HOME}/.ssh/authorized_keys\"\n"
    chmod 644 "${HOME}/.ssh/authorized_keys"

    # config should be 644
    _echo_info "chmod 644 \"${HOME}/.ssh/config\"\n"
    chmod 644 "${HOME}/.ssh/config"

    # known_hosts should be 644 as well
    _echo_info "chmod 644 \"${HOME}/.ssh/known_hosts\"\n"
    chmod 644 "${HOME}/.ssh/known_hosts"
}
