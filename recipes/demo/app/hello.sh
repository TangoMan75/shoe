#!/bin/sh

## Hello World!
##
## Greets a specified recipient.
##
## @namespace recipes/demo/app
## @requires printf true
## @depends src/shell/colors/_echo_info.sh
## @assumes verbose
## @param {str} <recipient> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
hello() {
    if [ "${verbose}" = true ]; then
        _echo_info "printf 'Hello, %s !\\\n' \"\${recipient}\"\n"
    fi

    printf 'Hello, %s !\n' "${recipient}"
}

