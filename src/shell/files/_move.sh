#!/bin/sh

## Move file or folder to destination (creates folder when missing)
##
## @namespace src/shell/files
## @requires cp mkdir mv realpath rm
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
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

    # Refuse a destination that is the source itself or one of its
    # descendants: copying a folder into itself would recurse forever and
    # the source is removed afterwards.
    case "$(realpath "$2")" in
        "$1"|"$1"/*)
            _echo_error "_move: destination \"$2\" is inside source \"$1\"\n"

            return 1
            ;;
    esac

    # `cp -R SOURCE/. DESTINATION`
    # will effectively merge folders when destination exists without leaving dotfiles behind
    # (files in destination will overwriten)
    _echo_info "cp -R \"$1/.\" \"$2\"\n"
    if ! cp -R "$1/." "$2"; then
        _echo_error "_move: could not copy \"$1\" to \"$2\"\n"

        return 1
    fi

    _echo_info "rm -rf \"$1\"\n"
    rm -rf "$1"
}

