#!/bin/sh

## Lint Python files with ruff
##
## @namespace src/shell/python
## @requires find grep printf ruff sort
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/system/_check_installed.sh
## @flag <fix> [-f|--fix] Autofix lint errors.
_lint_with_ruff() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-f' ] || [ "$1" = '--fix' ]; then
            set -- "$@" '--fix'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_lint_with_ruff\n'
            _echo_success 'description:' 2 14; _echo_primary 'Lint Python files with ruff\n'
            _echo_success 'usage:' 2 14; _echo_primary '_lint_with_ruff -f (fix) -h (help)\n'

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

    # Record layout: $1: fix flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--fix'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--fix' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_lint_with_ruff -f (fix) -h (help)\n'

        return 1
    fi

    _check_installed ruff

    if [ "$1" = 'true' ]; then
        find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r __file__; do
            _echo_info "ruff check --fix \"${__file__}\"\n"
            ruff check --fix "${__file__}"
        done

        return 0
    fi

    find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r __file__; do
        _echo_info "ruff check \"${__file__}\"\n"
        ruff check "${__file__}"
    done
}

