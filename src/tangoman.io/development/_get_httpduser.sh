#!/bin/sh

## Returns httpsuser
_get_httpduser() {
    _httpduser=''

    if [ -x "$(command -v ps)" ]; then
        # https://symfony.com/doc/current/setup/file_permissions.html
        # shellcheck disable=SC2009
        _httpduser=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)
    fi

    if [ -z "${_httpduser}" ]; then
        echo www-data
    else
        echo "${_httpduser}"
    fi
}

