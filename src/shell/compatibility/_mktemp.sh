#!/bin/sh

## Create a temporary file and print its path
##
## A template is always passed to mktemp because GNU mktemp falls back to
## a default one, while BusyBox and macOS require one. The file is created
## in TMPDIR, or /tmp when TMPDIR is unset, unless a directory is given.
## A complete template ending with "XXXXXX" is passed through unchanged.
##
## @namespace src/shell/compatibility
## @requires mktemp
## @depends src/shell/colors/_echo_error.sh
## @assumes TMPDIR
## @param {str} <PREFIX> (default:"tmp") Prefix of the temporary file name, or a complete template ending with "XXXXXX".
## @param {folder} <DIRECTORY> (default:"/tmp") Folder receiving the temporary file. Ignored when a complete template is given.
_mktemp() {
    if [ $# -gt 2 ]; then _echo_error "_mktemp: too many arguments ($#)\n"; return 1; fi

    case "${1:-tmp}" in
        *XXXXXX*) set -- "$1" ;;
        *) set -- "${2:-${TMPDIR:-/tmp}}/${1:-tmp}.XXXXXX" ;;
    esac

    mktemp "$1" 2>/dev/null || {
        _echo_error '_mktemp: could not create temporary file\n'

        return 1
    }
}

