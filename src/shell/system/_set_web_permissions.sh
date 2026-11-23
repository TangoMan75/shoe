#!/bin/sh

## Grant the web server user read and write access to a folder
##
## Uses setfacl so the permissions are inherited by future files and
## folders without changing the owner of the project files.
##
## @namespace src/shell/system
## @requires awk command printf realpath setfacl
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/system/_get_web_user.sh
## @param {folder} <DIRECTORY> (required) The folder to grant access to.
## @option {str} <HTTPD_USER> [-u] (default:"_get_web_user") The web server user.
_set_web_permissions() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-u' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-u" requires value\n'

                return 1
            fi
            set -- "$@" '--user' "$2"
            shift 2
        elif [ "$1" = '-h' ]; then
            _echo_warning '_set_web_permissions\n'
            _echo_success 'description:' 2 14; _echo_primary 'Grant the web server user access to a folder\n'
            _echo_success 'usage:' 2 14; _echo_primary '_set_web_permissions [directory] -u (user) -h (help)\n'

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

    # Record layout: $1: httpd user, $2..: positional parameters.
    if printf '%s\n' "$@" | awk '/^--user$/ { found = 1 } END { exit !found }'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--user$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- '' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--user' ]; then
            shift
            if [ "$1" != '__END_OF_OPTIONS__' ]; then shift; fi
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    #--------------------------------------------------
    # Check setfacl installation
    #--------------------------------------------------

    if ! command -v setfacl >/dev/null 2>&1; then
        _echo_error '_set_web_permissions: setfacl required, try "sudo apt-get install -y acl"\n'

        return 1
    fi

    if [ -z "$2" ]; then
        _echo_error '_set_web_permissions: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_set_web_permissions [directory] -u (user) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_set_web_permissions: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_set_web_permissions [directory] -u (user) -h (help)\n'

        return 1
    fi

    if [ ! -d "$2" ]; then
        _echo_error "_set_web_permissions: \"$2\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$(realpath -- "$2")"

    if [ -z "$1" ]; then
        set -- "$(_get_web_user)" "$2"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # set permissions for future files and folders
    _echo_info "setfacl -dR -m \"u:$1:rwX\" \"$2\"\n"
    setfacl -dR -m "u:$1:rwX" "$2"

    # set permissions on the existing files and folders
    _echo_info "setfacl -R -m \"u:$1:rwX\" \"$2\"\n"
    setfacl -R -m "u:$1:rwX" "$2"
}

