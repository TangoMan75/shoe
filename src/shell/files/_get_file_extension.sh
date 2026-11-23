#!/bin/sh

## Get file extension
##
## @namespace src/shell/files
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_file_extension() {
    if [ -z "$1" ]; then _echo_error '_get_file_extension: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_file_extension: too many arguments ($#)\n"; return 1; fi

    # Only the basename takes part in the extension, and a dotfile such
    # as ".bashrc" keeps its whole name.
    set -- "${1##*/}"
    case "$1" in
        *.*) printf '.%s\n' "${1##*.}" ;;
        *) return 1 ;;
    esac
}

