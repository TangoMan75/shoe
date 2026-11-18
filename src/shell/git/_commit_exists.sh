#!/bin/sh

## Check if a git commit exists in the repository
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <COMMIT_HASH> (required) The commit hash to check.
## @flag <verbose> [-v] Print the command before execution.
_commit_exists() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_commit_exists\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check commit exists\n'
            _echo_success 'usage:' 2 14; _echo_primary '_commit_exists [commit_hash] -v (verbose) -h (help)\n'

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
        _echo_error '_commit_exists: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_commit_exists [commit_hash] -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_commit_exists: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_commit_exists [commit_hash] -v (verbose) -h (help)\n'

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

    if [ "$1" = 'true' ]; then
        _echo_info "git cat-file commit $2 >/dev/null 2>&1 && echo true || echo false\n"
    fi

    if git cat-file commit "$2" >/dev/null 2>&1; then
        printf 'true\n'

        return 0
    fi

    printf 'false\n'
}

