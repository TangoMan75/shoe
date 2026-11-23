#!/bin/sh

## Set new host in the local hosts file
##
## The hostname is validated before use, and the entry is appended
## without going through a nested shell.
##
## @namespace src/shell/network
## @requires printf sudo tee
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/network/_remove_host.sh
## @assumes HOSTS_FILE
## @param {str} <HOSTNAME> (required) The hostname to set locally.
_set_host() {
    if [ -z "$1" ]; then _echo_error '_set_host: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_set_host: too many arguments ($#)\n"; return 1; fi

    case "$1" in
        *[!A-Za-z0-9.-]*)
            _echo_error "_set_host: invalid hostname \"$1\"\n"

            return 1
            ;;
    esac

    _remove_host "$1"

    set -- "$1" "${HOSTS_FILE:-/etc/hosts}"

    _echo_info "printf '127.0.0.1    %s\\n' \"$1\" | sudo tee -a \"$2\"\n"
    if ! printf '127.0.0.1    %s\n' "$1" | sudo tee -a "$2" >/dev/null; then
        _echo_error "_set_host: could not update \"$2\"\n"

        return 1
    fi
}

