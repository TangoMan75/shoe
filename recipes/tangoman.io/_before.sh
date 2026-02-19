#!/bin/sh

# Place here commands you need executed first every time
_before() {
    if ! requirements; then
        return 1
    fi

    # this will resolve to current project directory
    # or to "pwd" when script is installed globally via copy
    # remove if you don't need script to change to project directory
    cd "$(_pwd)" || return 1
}

