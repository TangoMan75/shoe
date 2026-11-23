#!/bin/sh

## Print the external IPv4 address of the current connection
##
## Tries curl first and falls back to wget. The icanhazip service is used
## first, then ipify when the first service cannot be reached.
##
## @namespace src/shell/network
## @requires command curl printf wget
## @depends src/shell/colors/_echo_error.sh
_get_external_ip() {
    if [ "$#" -gt 0 ]; then _echo_error "_get_external_ip: too many arguments ($#)\n"; return 1; fi

    if command -v curl >/dev/null 2>&1; then
        set -- "$(curl -fsSL 'https://ipv4.icanhazip.com' \
            || curl -fsSL 'https://api.ipify.org')"
        if [ -n "$1" ]; then
            printf '%s\n' "$1"

            return 0
        fi

        _echo_error '_get_external_ip: could not reach the ip service\n'

        return 1
    fi

    if command -v wget >/dev/null 2>&1; then
        set -- "$(wget -qO- 'https://ipv4.icanhazip.com' \
            || wget -qO- 'https://api.ipify.org')"
        if [ -n "$1" ]; then
            printf '%s\n' "$1"

            return 0
        fi

        _echo_error '_get_external_ip: could not reach the ip service\n'

        return 1
    fi

    _echo_error '_get_external_ip: curl or wget required\n'

    return 1
}

