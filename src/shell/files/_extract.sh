#!/bin/sh

## Extract file based on its extension
##
## {
##   "namespace": "files",
##   "requires": [
##     "realpath",
##     "tar",
##     "unzip"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 1,
##       "name": "DESTINATION_FOLDER",
##       "type": "folder",
##       "description": "The path to the destination folder. Defaults to file parent."
##     }
##   ]
## }
_extract() {
    # Synopsis: _extract <FILE_PATH> [DESTINATION_FOLDER]
    #   FILE_PATH:          The path to the input file.
    #   DESTINATION_FOLDER: (optional) The path to the destination folder. Defaults to file parent.

    if [ -z "$1" ]; then _echo_error '_extract: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_extract: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}"
    if [ ! -f "$1" ]; then _echo_error "_extract: \"$1\" file not found\n"; return 1; fi

    # ${1##*.} : This is a parameter expansion expression
    #       ## : Removes the shortest pattern that matches the entire string from the end of the value
    #        * : Matches zero or more characters
    #        . : Matches a literal dot (.)
    if [ "${1##*.}" = gz ]; then
        _check_installed tar

        # extract with tar
        # -x, --extract
        # -v, --verbose
        # -z, --gzip, --gunzip --ungzip
        # -f, --file [ARCHIVE]
        # -C, --directory [DIR] : destination directory
        _echo_info "tar -xvzf \"$1\" -C \"$2\"\n"
        tar -xvzf "$1" -C "$2"

        return 0
    fi

    if [ "${1##*.}" = zip ]; then
        _check_installed unzip

        _echo_info "unzip \"$1\" -d \"$2\"\n"
        unzip "$1" -d "$2"

        return 0
    fi

    _echo_error "Unsupported archive format \"${1##*.}\".\n"
}

