#!/bin/sh

## Remove hostname from the local hosts file
##
## The hostname is matched against every alias of each entry, and the
## hosts file is replaced atomically through a temporary copy.
##
## @namespace src/shell/network
## @requires awk cp mktemp rm sudo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @assumes HOSTS_FILE TMPDIR
## @param {str} <HOSTNAME> (required) The hostname to unset locally.
_remove_host() {
    if [ -z "$1" ]; then _echo_error '_remove_host: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_remove_host: too many arguments ($#)\n"; return 1; fi

    # Reject characters that could be interpreted by the hosts file
    # parsers or by the shell.
    case "$1" in
        *[!A-Za-z0-9.-]*)
            _echo_error "_remove_host: invalid hostname \"$1\"\n"

            return 1
            ;;
    esac

    set -- "$1" "${HOSTS_FILE:-/etc/hosts}"

    if [ ! -f "$2" ]; then
        _echo_error "_remove_host: \"$2\" file not found\n"

        return 1
    fi

    __tmp__=$(mktemp "${TMPDIR:-/tmp}/remove_host.XXXXXX") || {
        _echo_error '_remove_host: could not create a temporary file\n'

        return 1
    }
    set -- "$1" "$2" "$__tmp__"
    if ! awk -v host="$1" '
        {
            keep = 1
            for (field = 2; field <= NF; field++) {
                if ($field == host) keep = 0
            }
            if (keep) print
        }
    ' "$2" > "$3"; then
        rm -f "$3"
        _echo_error "_remove_host: could not read \"$2\"\n"

        return 1
    fi

    _echo_info "sudo cp \"$3\" \"$2\"\n"
    if ! sudo cp "$3" "$2"; then
        rm -f "$3"
        _echo_error "_remove_host: could not update \"$2\"\n"

        return 1
    fi

    rm -f "$3"
}

