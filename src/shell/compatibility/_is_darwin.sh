#!/bin/sh

## Check current system is Darwin
##
## @namespace src/shell/compatibility
## @requires uname
_is_darwin() {
    if [ "$(uname -s)" != 'Darwin' ]; then

        return 1
    fi

    return 0
}

