#!/bin/sh

## Run following code before each execution
_before() {
    if ! requirements; then
        return 1
    fi

    cd "$(_pwd)" || return 1
}

