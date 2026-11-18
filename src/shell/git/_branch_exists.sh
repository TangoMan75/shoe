#!/bin/sh

## Check if a git branch exists in the local or remote repository
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <BRANCH> (required) The branch name to check.
## @flag <all> [-a] Search all references.
## @flag <remotes> [-r] Search remote branches only.
## @flag <verbose> [-v] Print the command before execution.
_branch_exists() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-a' ]; then
            set -- "$@" '--all'
            shift
        elif [ "$1" = '-r' ]; then
            set -- "$@" '--remotes'
            shift
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_branch_exists\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check branch exists\n'
            _echo_success 'usage:' 2 14; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'

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
    # $1: all flag, $2: remotes flag, $3: verbose flag,
    # $4..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--remotes'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--all'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--all' ] || [ "$1" = '--remotes' ] \
            || [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$4" ]; then
        _echo_error '_branch_exists: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 4 ]; then
        _echo_error "_branch_exists: too many arguments ($(( $# - 3 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'

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

    if [ "$3" = 'true' ]; then
        if [ "$1" = 'true' ]; then
            _echo_info "git show-ref --quiet $4 && echo true || echo false\n"
        elif [ "$2" = 'true' ]; then
            _echo_info "git show-ref --verify --quiet refs/remotes/origin/$4 && echo true || echo false\n"
        else
            _echo_info "git show-ref --quiet --heads $4 && echo true || echo false\n"
        fi
    fi

    if [ "$1" = 'true' ]; then
        if git show-ref --quiet "$4" >/dev/null 2>&1; then
            printf 'true\n'

            return 0
        fi
    elif [ "$2" = 'true' ]; then
        if git show-ref --verify --quiet \
            "refs/remotes/origin/$4" >/dev/null 2>&1; then
            printf 'true\n'

            return 0
        fi
    else
        if git show-ref --quiet --heads "$4" >/dev/null 2>&1; then
            printf 'true\n'

            return 0
        fi
    fi

    printf 'false\n'
}

