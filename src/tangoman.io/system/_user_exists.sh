#!/bin/sh

## Check user exists
_user_exists() {
    if [ ! -x "$(command -v id)" ]; then
        echo_error "\"$(basename "${0}")\" requires id\n"
        return 1
    fi

    if [ $# -lt 1 ]; then
        echo_error 'some mandatory argument is missing\n'
        return 1
    fi

    if [ $# -gt 1 ]; then
        echo_error "too many arguments: expected 1, $# given.\n"
        return 1
    fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ];then
        echo true
        return 0
    fi

    echo false
}

