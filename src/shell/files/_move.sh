#!/bin/sh

## Move file or folder to destination (creates folder when missing)
##
## {
##   "namespace": "files",
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SOURCE",
##       "type": "path",
##       "description": "The path to the input file or folder.",
##       "nullable": false
##     },
##     {
##       "position": 1,
##       "name": "DESTINATION",
##       "type": "folder",
##       "description": "The path to the destination folder.",
##       "nullable": false
##     }
##   ]
## }
_move() {
    # Synopsis: _move <SOURCE> <DESTINATION>
    #   SOURCE:      The path to the input file or folder.
    #   DESTINATION: The path to the destination folder.

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

