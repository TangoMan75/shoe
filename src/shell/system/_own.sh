#!/bin/sh

## Change the owner of a file or folder
##
## @namespace src/shell/system
## @requires awk chown printf realpath sudo whoami
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {path} <SOURCE> (required) The file or folder to update.
## @option {str} <USER> [-u] (default:"current user") The owner user name.
## @option {str} <GROUP> [-g] (default:"owner user") The owner group name.
## @flag <nobody> [-n] Set the owner to nobody:nogroup.
## @flag <recursive> [-r] Change the owner recursively.
## @flag <root> [-R] Set the owner to root.
## @flag <sudo> [-s] Execute chown with sudo.
_own() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-n' ]; then
            set -- "$@" '--nobody'
            shift
        elif [ "$1" = '-r' ]; then
            set -- "$@" '--recursive'
            shift
        elif [ "$1" = '-R' ]; then
            set -- "$@" '--root'
            shift
        elif [ "$1" = '-s' ]; then
            set -- "$@" '--sudo'
            shift
        elif [ "$1" = '-u' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-u" requires value\n'

                return 1
            fi
            set -- "$@" '--user' "$2"
            shift 2
        elif [ "$1" = '-g' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-g" requires value\n'

                return 1
            fi
            set -- "$@" '--group' "$2"
            shift 2
        elif [ "$1" = '-h' ]; then
            _echo_warning '_own\n'
            _echo_success 'description:' 2 14; _echo_primary 'Change the owner of a file or folder\n'
            _echo_success 'usage:' 2 14; _echo_primary '_own [source] -u (user) -g (group) -n (nobody) -R (root) -r (recursive) -s (sudo) -h (help)\n'

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
    # $1: recursive flag, $2: sudo flag, $3: group, $4: user,
    # $5..: positional parameters.
    set -- "$(printf '%s\n' "$@" | awk -v fallback="$(whoami)" '
        /^--user$/ { getline; user = $0 }
        /^--root$/ { user = "root" }
        /^--nobody$/ { user = "nobody" }
        END { print (user == "" ? fallback : user) }')" "$@"
    set -- "$(printf '%s\n' "$@" | awk -v fallback="$1" '
        /^--group$/ { getline; group = $0 }
        /^--nobody$/ { group = "nogroup" }
        END { print (group == "" ? fallback : group) }')" "$@"
    if printf '%s\n' "$@" | awk '/^--sudo$/ { found = 1 } END { exit !found }'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | awk '/^--recursive$/ { found = 1 } END { exit !found }'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--recursive' ] || [ "$1" = '--sudo' ] \
            || [ "$1" = '--root' ] || [ "$1" = '--nobody' ]; then
            shift
        elif [ "$1" = '--user' ] || [ "$1" = '--group' ]; then
            shift 2
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$5" ]; then
        _echo_error '_own: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_own [source] -u (user) -g (group) -n (nobody) -R (root) -r (recursive) -s (sudo) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 5 ]; then
        _echo_error "_own: too many arguments ($(( $# - 4 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_own [source] -u (user) -g (group) -n (nobody) -R (root) -r (recursive) -s (sudo) -h (help)\n'

        return 1
    fi

    if [ ! -f "$5" ] && [ ! -d "$5" ]; then
        _echo_error "_own: source: \"$5\" is invalid\n"

        return 1
    fi

    if [ ! -d "$5" ] && [ "$1" = 'true' ]; then
        _echo_error "_own: source: \"$5\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$2" "$3" "$4" "$(realpath "$5")"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        if [ "$2" = 'true' ]; then
            _echo_info "sudo chown \"$4:$3\" -R \"$5\"\n"
            sudo chown "$4:$3" -R "$5"
        else
            _echo_info "chown \"$4:$3\" -R \"$5\"\n"
            chown "$4:$3" -R "$5"
        fi

        return 0
    fi

    if [ "$2" = 'true' ]; then
        _echo_info "sudo chown \"$4:$3\" \"$5\"\n"
        sudo chown "$4:$3" "$5"
    else
        _echo_info "chown \"$4:$3\" \"$5\"\n"
        chown "$4:$3" "$5"
    fi
}

