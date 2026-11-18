#!/bin/sh

## Check current system is Linux
##
## Android and WSL also report a Linux kernel
##
## @namespace src/shell/compatibility
## @requires uname
_is_linux() {
    if [ "$(uname -s)" != 'Linux' ]; then

        return 1
    fi

    return 0
}

