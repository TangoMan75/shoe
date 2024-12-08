#!/bin/sh

# Place here commands you need executed first every time
_before() {
    _check_installed awk
    _check_installed sed

    # this will resolve to current project directory
    # or to "pwd" when script is installed globally via copy
    # uncomment if you need script to change to project directory everytime
    # cd "$(_pwd)" || return 1
}

