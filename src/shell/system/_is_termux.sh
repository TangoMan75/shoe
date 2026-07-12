#!/bin/sh

## Check current environment is Termux
##
## {
##   "namespace": "system"
## }
_is_termux() {
    # Synopsis: _is_termux

    if [ ! -d '/data/data/com.termux' ]; then

        return 1
    fi

    return 0
}

