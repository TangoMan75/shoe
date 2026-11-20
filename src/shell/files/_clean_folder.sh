#!/bin/sh

## Recursively delete common junk files and folders
##
## Removes "__MACOSX" and "__pycache__" folders, "desktop.ini",
## "Thumbs.db", "*.log", ".DS_Store" and undo scripts.
##
## @namespace src/shell/files
## @requires find realpath rm
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {folder} <SOURCE> (required) The folder to clean.
_clean_folder() {
    if [ -z "$1" ]; then _echo_error '_clean_folder: some mandatory parameter is missing\n'; return 1; fi
    if [ "$#" -gt 1 ]; then _echo_error "_clean_folder: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$1" ]; then
        _echo_error "_clean_folder: \"$1\" is not a valid directory\n"

        return 1
    fi

    set -- "$(realpath "$1")"

    _echo_info "find \"$1\" -type d -name \"__MACOSX\" -exec rm -rf '{}' +\n"
    find "$1" -type d -name "__MACOSX" -exec rm -rf {} +

    _echo_info "find \"$1\" -type d -name \"__pycache__\" -exec rm -rf '{}' +\n"
    find "$1" -type d -name "__pycache__" -exec rm -rf {} +

    _echo_info "find \"$1\" -type f -iname desktop.ini -exec rm -f {} +\n"
    find "$1" -type f -iname desktop.ini -exec rm -f {} +

    _echo_info "find \"$1\" -type f -iname thumbs.db -exec rm -f {} +\n"
    find "$1" -type f -iname thumbs.db -exec rm -f {} +

    _echo_info "find \"$1\" -type f -name '*.log' -exec rm -f {} +\n"
    find "$1" -type f -name '*.log' -exec rm -f {} +

    _echo_info "find \"$1\" -type f -name .DS_Store -exec rm -f {} +\n"
    find "$1" -type f -name .DS_Store -exec rm -f {} +

    _echo_info "find \"$1\" -type f -name '*_undo.sh' -exec rm -f {} +\n"
    find "$1" -type f -name "*_undo.sh" -exec rm -f {} +
}

