#!/bin/sh

## Return the command that resolves a canonical path
##
## @namespace src/shell/compatibility
## @requires command printf readlink realpath
## @depends src/shell/colors/_echo_error.sh
_readlink() {
    set -- realpath greadlink readlink

    while [ $# -gt 0 ]; do
        if command -v "$1" >/dev/null 2>&1; then
            case "$1" in
                greadlink) set -- 'greadlink -f' ;;
                readlink)
                    if "$1" -f '/' >/dev/null 2>&1; then
                        set -- 'readlink -f'
                    else
                        shift
                        continue
                    fi
                    ;;
            esac

            printf '%s' "$1"

            return 0
        fi

        shift
    done

    _echo_error '_readlink: no canonical path command found\n'

    return 1
}

