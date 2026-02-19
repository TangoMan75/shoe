#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager/ssh",
##   "summary": "Config ssh file permissions",
##   "requires": [
##     "chmod",
##     "chown",
##     "find"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_echo_info"
##   ]
## }
config_ssh_file_permissions() {
    _alert_secondary 'config ssh file permissions'

    # correct ssh permissions
    _echo_info "chown \"${USER}\":\"${USER}\" -R \"${HOME}/.ssh\"\n"
    chown "${USER}":"${USER}" -R "${HOME}/.ssh"

    # the .ssh directory should be 700 (drwx----)
    _echo_info "chmod 700 \"${HOME}/.ssh\"\n"
    chmod 700 "${HOME}/.ssh"

    # the private keys should be 600 (-rw-------)
    # only apply this to regular files, never to directories or sockets
    _echo_info "find \"${HOME}/.ssh\" -maxdepth 1 -type f ! -name '*.pub' -exec chmod 600 {} +\n"
    find "${HOME}/.ssh" -maxdepth 1 -type f ! -name '*.pub' -exec chmod 600 {} +

    # the public keys (.pub) should be 644 (-rw-r--r--)
    _echo_info "find \"${HOME}/.ssh\" -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +\n"
    find "${HOME}/.ssh" -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +

    # authorized_keys, config and known_hosts should be 644 as well
    for __file__ in authorized_keys config known_hosts; do
        if [ -f "${HOME}/.ssh/${__file__}" ]; then
            _echo_info "chmod 644 \"${HOME}/.ssh/${__file__}\"\n"
            chmod 644 "${HOME}/.ssh/${__file__}"
        fi
    done
}

