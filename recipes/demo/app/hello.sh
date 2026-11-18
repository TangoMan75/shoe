#!/bin/sh

## Hello World!
##
## Greets a specified user.
##
## @namespace recipes/demo/app
## @requires printf true
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @assumes verbose
## @param {str} <WHO> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
hello() {
    if [ $# -gt 1 ]; then
        _echo_error "hello: too many arguments ($#)"
        return 1
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "printf 'Hello, %s !\\\n' \"\${1:-World}\"\n"
    fi

    printf 'Hello, %s !\n' "${1:-World}"
}

