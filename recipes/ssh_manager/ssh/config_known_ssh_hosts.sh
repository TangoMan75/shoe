#!/bin/sh

## Config known ssh hosts
config_known_ssh_hosts() {
    _alert_primary 'config known ssh hosts'

    set -- "${HOME}/.ssh/known_hosts"

    # create ~/.ssh/known_hosts if not exists
    _echo_info "touch \"$1\"\n"
    touch "$1"

    # add github.com, gitlab.com and bitbucket.org keys to known_hosts
    _echo_info "ssh-keyscan -H github.com >> \"$1\"\n"
    ssh-keyscan -H github.com >> "$1"

    _echo_info "ssh-keyscan -H gist.github.com >> \"$1\"\n"
    ssh-keyscan -H gist.github.com >> "$1"

    _echo_info "ssh-keyscan -H bitbucket.org >> \"$1\"\n"
    ssh-keyscan -H bitbucket.org >> "$1"

    _echo_info "ssh-keyscan -H gitlab.com >> \"$1\"\n"
    ssh-keyscan -H gitlab.com >> "$1"

    _echo_info "chmod 644 \"$1\"\n"
    chmod 644 "$1"

    _echo_info "chown \"${USER}:${USER}\" \"$1\"\n"
    chown "${USER}:${USER}" "$1"
}
