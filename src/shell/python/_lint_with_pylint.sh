#!/bin/sh

## Lint Python files with pylint
##
## @namespace src/shell/python
## @requires find pylint sort
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/system/_check_installed.sh
_lint_with_pylint() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-h' ]; then
            _echo_warning '_lint_with_pylint\n'
            _echo_success 'description:' 2 14; _echo_primary 'Lint Python files with pylint\n'
            _echo_success 'usage:' 2 14; _echo_primary '_lint_with_pylint -h (help)\n'

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

    if [ "$#" -gt 0 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _echo_success 'usage:' 2 8; _echo_primary '_lint_with_pylint -h (help)\n'

        return 1
    fi

    _check_installed pylint

    _echo_info 'pylint --version\n'
    pylint --version

    find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r __file__; do
        _echo_info "pylint --max-line-length 255 \"${__file__}\"\n"
        pylint --max-line-length 255 "${__file__}"
    done
}

