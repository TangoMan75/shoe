#!/bin/sh

## Print the DNS records of a domain
##
## @namespace src/shell/network
## @requires awk command dig grep printf
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @param {str} <DOMAIN> (required) The domain to check.
## @option {str} <RECORD_TYPE> [-t] (default:"A") The DNS record type to query.
_check_dns() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-t' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-t" requires value\n'

                return 1
            fi
            set -- "$@" '--type' "$2"
            shift 2
        elif [ "$1" = '-h' ]; then
            _echo_warning '_check_dns\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check DNS records\n'
            _echo_success 'usage:' 2 14; _echo_primary '_check_dns [domain] -t (record type) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: record type, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--type'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--type$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- 'A' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--type' ]; then
            shift 2
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    #--------------------------------------------------
    # Check dig installation
    #--------------------------------------------------

    if ! command -v dig >/dev/null 2>&1; then
        _echo_error '_check_dns: dig required, try "sudo apt-get install -y dnsutils"\n'

        return 1
    fi

    if [ -z "$2" ]; then
        _echo_error '_check_dns: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_check_dns [domain] -t (record type) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_check_dns: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_check_dns [domain] -t (record type) -h (help)\n'

        return 1
    fi

    _echo_info "dig \"$2\" \"$1\" +nostats +nocomments +nocmd\n"
    dig "$2" "$1" +nostats +nocomments +nocmd
}

