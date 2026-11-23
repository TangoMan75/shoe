#!/bin/sh

## Select a repository interactively from a GitHub user's repositories
##
## @namespace src/shell/git
## @requires awk grep printf rm sed true
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/compatibility/_mktemp.sh
## @depends src/shell/git/_list_github.sh
## @param {str} <OWNER> (required) The GitHub user name.
_pick_repository() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-h' ]; then
            _echo_warning '_pick_repository\n'
            _echo_success 'description:' 2 14; _echo_primary 'Select a repository among multiple options\n'
            _echo_success 'usage:' 2 14; _echo_primary '_pick_repository [user_name] -h (help)\n'

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
        _echo_error '_pick_repository: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_pick_repository [user_name] -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 1 ]; then
        _echo_error "_pick_repository: too many arguments ($#)\n"
        _echo_success 'usage:' 2 8; _echo_primary '_pick_repository [user_name] -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Collect repositories
    #--------------------------------------------------

    # $2: repository file.
    __repository_file__=$(_mktemp 'pick_repository') || return 1
    set -- "$1" "$__repository_file__"
    if [ -z "$2" ]; then
        _echo_error '_pick_repository: could not create temporary file\n'

        return 1
    fi

    _list_github "$1" > "$2" || true

    if [ ! -s "$2" ]; then
        rm -f "$2"
        _echo_danger 'error: No repositories found\n'

        return 1
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    awk '{ printf "%d) %s\n", NR, $0 }' "$2"
    _echo_success 'Please select repository : \n'

    # $1: repository file, $2: repository count, $3: selection.
    set -- "$2" "$(awk 'END { print NR }' "$2")" 0
    while [ "$3" -lt 1 ] || [ "$3" -gt "$2" ]; do
        set -- "$1" "$2" \
            "$(awk 'NR == 1 { gsub(/^[ \t]+|[ \t]+$/, ""); print; exit }')"
        if [ -z "$3" ]; then
            rm -f "$1"

            return 1
        fi
        if printf '%s' "$3" | grep -q -x -e '[0-9][0-9]*'; then
            :
        else
            set -- "$1" "$2" 0
        fi
    done

    sed -n "$3p" "$1"
    rm -f "$1"
}

