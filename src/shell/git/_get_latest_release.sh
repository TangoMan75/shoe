#!/bin/sh

## Get repository latest release version from github
##
## @namespace src/shell/git
## @requires command curl grep sed
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <REPOSITORY> (required) Owner and repository name in the form: owner/repository.
_get_latest_release() {
    if ! command -v curl >/dev/null 2>&1; then
        _echo_danger 'error: curl required, try: "sudo apt-get install -y curl"\n'

        return 1
    fi

    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-h' ]; then
            _echo_warning '_get_latest_release\n'
            _echo_success 'description:' 2 14; _echo_primary 'Get repository latest release\n'
            _echo_success 'usage:' 2 14; _echo_primary '_get_latest_release [owner/repository] -h (help)\n'

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

    if [ -z "$1" ]; then
        _echo_error '_get_latest_release: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_get_latest_release [owner/repository] -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 1 ]; then
        _echo_error "_get_latest_release: too many arguments ($#)\n"
        _echo_success 'usage:' 2 8; _echo_primary '_get_latest_release [owner/repository] -h (help)\n'

        return 1
    fi

    curl --silent "https://api.github.com/repos/$1/releases/latest" \
        | grep '"tag_name":' \
        | sed -e 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/' \
        | sed -e 's/^[vV]ersion//' -e 's/^[vV]//'
}

