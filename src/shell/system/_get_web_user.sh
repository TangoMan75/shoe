#!/bin/sh

## Print the user running the web server
##
## Falls back to "www-data" when no common web server process is found.
##
## @namespace src/shell/system
## @requires awk comm command grep head printf ps true
_get_web_user() {
    if command -v ps >/dev/null 2>&1; then
        # https://symfony.com/doc/current/setup/file_permissions.html
        # shellcheck disable=SC2009
        set -- "$(ps axo user,comm 2>/dev/null \
            | grep -e '[a]pache' -e '[h]ttpd' -e '[_]www' \
                -e '[w]ww-data' -e '[n]ginx' \
            | grep -v root \
            | head -n 1 \
            | awk '{print $1}' || true)"
        if [ -n "$1" ]; then
            printf '%s\n' "$1"

            return 0
        fi
    fi

    printf 'www-data\n'

    return 0
}

