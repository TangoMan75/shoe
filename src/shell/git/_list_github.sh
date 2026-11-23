#!/bin/sh

## Lists user's GitHub repositories
##
## @namespace src/shell/git
## @requires command curl grep jq printf
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @param {str} <OWNER> (required) GitHub owner name.
## @flag <verbose> [-v] Print command before execution.
_list_github() {
    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if ! command -v curl >/dev/null 2>&1; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check jq installation
    #--------------------------------------------------

    if ! command -v jq >/dev/null 2>&1; then
        _echo_danger 'error: jq required, enter: "sudo apt-get install -y jq" to install\n'

        return 1
    fi

    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_list_github\n'
            _echo_success 'description:' 2 14; _echo_primary "Lists user's GitHub repositories\n"
            _echo_success 'usage:' 2 14; _echo_primary '_list_github [owner] -v (verbose) -h (help)\n'

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

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$2" ]; then
        _echo_error '_list_github: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_list_github [owner] -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_list_github: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_list_github [owner] -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        _echo_info "curl -s \"https://api.github.com/users/$2/repos\" | jq -r '.[].html_url'\n"
    fi

    curl -s "https://api.github.com/users/$2/repos" | jq -r '.[].html_url'
}

