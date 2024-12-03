#!/bin/sh

## Check user exists
_user_exists() {
    if [ ! -x "$(command -v id)" ]; then
        echo_error "\"$(basename "${0}")\" requires id\n"
        return 1
    fi

    if [ -z "$1" ]; then echo_danger 'error: _user_exists: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _user_exists: too many arguments (${#})\n"; exit 1; fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ]; then

        return 0
    fi

    return 1
}

