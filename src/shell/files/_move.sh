#!/bin/sh

## Move file or folder to destination (creates folder when missing)
##
## @namespace src/shell/files
## @requires cp mkdir mv realpath rm
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {path} <SOURCE> (required) The path to the input file or folder.
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_move() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_move: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_move: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ] && [ ! -d "$1" ]; then _echo_error "_move: \"$1\" no such file or directory\n"; return 1; fi
    # create destination folder
    if [ ! -d "$2" ]; then _echo_info "mkdir -p \"$2\"\n"; mkdir -p "$2"; fi

    set -- "$(realpath "$1")" "$2"
    if [ -f "$1" ]; then
        _echo_info "mv \"$1\" \"$2\"\n"
        mv "$1" "$2"

        return 0
    fi

    # `cp -r SOURCE/. DESTINATION`
    # will effectively merge folders when destination exists without leaving dotfiles behind
    # (files in destination will overwriten)
    _echo_info "cp -r \"$1/.\" \"$2\"\n"
    cp -r "$1/." "$2"

    _echo_info "rm -rf \"$1\"\n"
    rm -rf "$1"
}

