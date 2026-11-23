#!/bin/sh

## Get the current git branch name
##
## @namespace src/shell/git
## @requires HEAD command git grep printf
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @flag <verbose> [-v] Print the command before execution.
_get_current_branch() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_get_current_branch\n'
            _echo_success 'description:' 2 14; _echo_primary 'Get current branch name\n'
            _echo_success 'usage:' 2 14; _echo_primary '_get_current_branch -v (verbose) -h (help)\n'

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

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_get_current_branch -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    __branch__="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ -z "${__branch__}" ] || [ "${__branch__}" = 'HEAD' ]; then
        # `git rev-parse --abbrev-ref HEAD` prints "HEAD" on a detached
        # checkout: that is not a branch name and breaks callers.
        _echo_error 'HEAD is detached, no branch is checked out\n'

        return 1
    fi

    if [ "$1" = 'true' ]; then
        _echo_info 'git rev-parse --abbrev-ref HEAD 2>/dev/null\n'
    fi

    printf '%s\n' "${__branch__}"
}

