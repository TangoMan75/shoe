#!/bin/sh

## Select a branch interactively from a list of git branches
##
## @namespace src/shell/git
## @requires HEAD awk command git grep printf rm sed true
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/compatibility/_mktemp.sh
## @depends src/shell/git/_get_main_branch.sh
## @option {str} <FILTER> [-F] Grep filter applied to the branch list.
## @flag <all> [-a] List all branches.
## @flag <current> [-c] Include the current branch.
## @flag <main> [-m] Include the main branch.
## @flag <verbose> [-v] Print the command before execution.
_pick_branch() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-a' ]; then
            set -- "$@" '--all'
            shift
        elif [ "$1" = '-c' ]; then
            set -- "$@" '--current'
            shift
        elif [ "$1" = '-F' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-F" requires value\n'

                return 1
            fi
            set -- "$@" '--filter' "$2"
            shift 2
        elif [ "$1" = '-m' ]; then
            set -- "$@" '--main'
            shift
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_pick_branch\n'
            _echo_success 'description:' 2 14; _echo_primary 'Select a branch among multiple options\n'
            _echo_success 'usage:' 2 14; _echo_primary '_pick_branch -F [file type filter] -a (list all) -m (list main) -c (list current) -v (verbose) -h (help)\n'

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
    # $1: filter, $2: all flag, $3: current flag, $4: main flag,
    # $5: verbose flag, $6..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--main'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--current'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--all'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--filter'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--filter$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- '' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--all' ] || [ "$1" = '--current' ] \
            || [ "$1" = '--main' ] || [ "$1" = '--verbose' ]; then
            shift
        elif [ "$1" = '--filter' ]; then
            shift
            if [ "$1" != '__END_OF_OPTIONS__' ]; then shift; fi
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 5 ]; then
        _echo_danger "error: too many arguments ($(( $# - 5 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_pick_branch -F [file type filter] -a (list all) -m (list main) -c (list current) -v (verbose) -h (help)\n'

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
    # Collect branches
    #--------------------------------------------------

    # $6: branch file, $7: main branch, $8: current branch.
    __branch_file__=$(_mktemp 'pick_branch') || return 1
    set -- "$1" "$2" "$3" "$4" "$5" "$__branch_file__" \
        "$(_get_main_branch)" "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ -z "$6" ]; then
        _echo_error '_pick_branch: could not create temporary file\n'

        return 1
    fi

    # main branch and current branch always first options
    if [ -n "$7" ] && [ "$8" != "$7" ] && [ "$4" = 'true' ]; then
        printf '%s\n' "$7" >> "$6"
    fi

    if [ "$3" = 'true' ]; then
        printf '%s\n' "$8" >> "$6"
    fi

    # $9: newline separated branch list, $10: display command.
    if [ "$2" = 'true' ]; then
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" \
            "$(git --no-pager branch --all --format='%(refname:short)')" \
            'git --no-pager branch --all'
    else
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" \
            "$(git --no-pager branch --format='%(refname:short)')" \
            'git --no-pager branch'
    fi
    set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" \
        "${10} --format=\"%(refname:short)\""
    if [ -n "$1" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" \
            "${10} | grep $1"
    fi

    if [ "$5" = 'true' ]; then
        _echo_info "${10}\n"
    fi

    if [ -n "$9" ]; then
        if [ -n "$1" ]; then
            printf '%s\n' "$9" | grep "$1" | sed -e 's/^origin\///' \
                | grep -F -v -x -e "$7" -e "$8" -e 'HEAD' >> "$6" || true
        else
            printf '%s\n' "$9" | sed -e 's/^origin\///' \
                | grep -F -v -x -e "$7" -e "$8" -e 'HEAD' >> "$6" || true
        fi
    fi

    if [ ! -s "$6" ]; then
        rm -f "$6"
        _echo_danger 'error: No branches found\n'

        return 1
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    awk '{ printf "%d) %s\n", NR, $0 }' "$6"
    _echo_success 'Please select branch : \n'

    # $1: branch file, $2: branch count, $3: selection.
    set -- "$6" "$(awk 'END { print NR }' "$6")" 0
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

