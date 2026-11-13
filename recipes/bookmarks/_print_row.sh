#!/bin/sh

## Print one bookmark row in the configured output format
##
## @namespace recipes/bookmarks
## @requires printf
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_primary src/shell/colors/_echo_success
## @assumes PADDING output
## @stdout the formatted bookmark row
## @param {str} <NAME> (required) The bookmark name.
## @param {str} <URL> (required) The bookmark URL.
_print_row() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_print_row: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_row: too many arguments ($#)\n"; return 1; fi

    case "${output}" in
        csv)
            printf '"%s","%s"\n' "$1" "$2"
            ;;
        plain)
            printf '%s\t%s\n' "$1" "$2"
            ;;
        *)
            _echo_success "$1" 2 "${PADDING}"
            _echo_primary "$2\n"
            ;;
    esac
}

