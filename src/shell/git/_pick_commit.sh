#!/bin/sh

## Select a commit interactively from a list of git commits
##
## @namespace src/shell/git
## @requires awk command cut git grep head printf rm sed true
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/compatibility/_mktemp.sh
## @param {str} <BRANCH> The branch to list commits from.
## @option {int} <COUNT> [-n] (default:16) The number of commits to list.
## @flag <verbose> [-v] Print the command before execution.
_pick_commit() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-n' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-n" requires value\n'

                return 1
            fi
            set -- "$@" '--count' "$2"
            shift 2
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_pick_commit\n'
            _echo_success 'description:' 2 14; _echo_primary 'Select a commit among multiple options\n'
            _echo_success 'usage:' 2 14; _echo_primary '_pick_commit (branch) -n [count] -v (verbose) -h (help)\n'

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
    # $1: count, $2: verbose flag, $3..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--count'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--count$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- '16' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        elif [ "$1" = '--count' ]; then
            shift
            if [ "$1" != '__END_OF_OPTIONS__' ]; then shift; fi
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 3 ]; then
        _echo_danger "error: too many arguments ($(( $# - 2 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_pick_commit (branch) -n [count] -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -lt 3 ]; then
        set -- "$1" "$2" ''
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
    # Collect commits
    #--------------------------------------------------

    # $4: commit file.
    __commit_file__=$(_mktemp 'pick_commit') || return 1
    set -- "$1" "$2" "$3" "$__commit_file__"
    if [ -z "$4" ]; then
        _echo_error '_pick_commit: could not create temporary file\n'

        return 1
    fi

    if [ -z "$3" ]; then
        # lists commits from current branch by default
        if [ "$2" = 'true' ]; then
            _echo_info "git --no-pager log --no-decorate --oneline -n $1\n"
        fi
        git --no-pager log --no-decorate --oneline -n "$1" \
            2>/dev/null > "$4" || true
    else
        if [ "$2" = 'true' ]; then
            _echo_info "git --no-pager log $3 --no-decorate --oneline -n $1\n"
        fi
        git --no-pager log "$3" --no-decorate --oneline \
            -n "$1" -- 2>/dev/null > "$4" || true
    fi

    if [ ! -s "$4" ]; then
        rm -f "$4"
        _echo_danger 'error: No commits found\n'

        return 1
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    awk '{ printf "%d) %s\n", NR, $0 }' "$4"
    _echo_success 'Please select commit : \n'

    # $1: commit file, $2: commit count, $3: selection.
    set -- "$4" "$(awk 'END { print NR }' "$4")" 0
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

    # get fully qualified hash
    # $4: selected line, $5: short hash, $6: commit hash.
    set -- "$1" "$2" "$3" "$(sed -n "$3p" "$1")"
    set -- "$1" "$2" "$3" "$4" "${4%% *}"
    set -- "$1" "$2" "$3" "$4" "$5" \
        "$(git --no-pager show -q --no-decorate "$5" \
            | head -n 1 | cut -d' ' -f2)"

    rm -f "$1"
    printf '%s' "$6"
}

