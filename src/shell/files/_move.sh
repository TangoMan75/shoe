#!/bin/sh

# Move file to destination folder (creates folder when missing)
_move() {
    # Synopsis: _move <FILE_PATH> <DESTINATION_FOLDER>
    #   FILE_PATH:          The path to the input file.
    #   DESTINATION_FOLDER: The path to the destination folder.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _move: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _move: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$(realpath "$2")"
    if [ ! -f "$1" ]; then echo_danger "error: _move: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_info "mkdir -p \"$2\"\n"; mkdir -p "$2"; fi

    echo_info "mv \"$1\" \"$2\"\n"
    mv "$1" "$2"
}

