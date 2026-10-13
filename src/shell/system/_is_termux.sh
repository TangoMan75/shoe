#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Check current environment is Termux"
## }
_is_termux() {
    if [ ! -d '/data/data/com.termux' ]; then

        return 1
    fi

    return 0
}

