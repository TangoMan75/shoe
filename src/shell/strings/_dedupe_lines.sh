#!/bin/sh

## Remove every line in target file that contains substrings from source file
##
## @namespace src/shell/strings
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_sed_i
## @param {file} <SOURCE_PATH> (required) The path to the file containing the substrings to remove.
## @param {file} <TARGET_PATH> (required) The path to the target file to deduplicate.
_dedupe_lines() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_dedupe_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_dedupe_lines: too many arguments ($#)\n"; return 1; fi
    set -- "$(realpath "$1")" "$(realpath "$2")"
    if [ ! -f "$1" ]; then _echo_error "_dedupe_lines: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then _echo_error "_dedupe_lines: \"$2\" file not found\n"; return 1; fi

    while read -r __substring__; do
        _echo_info "$(_sed_i) \"/${__substring__}/d\" \"$2\"\n"
        $(_sed_i) "/${__substring__}/d" "$2"
    done < "$1"
}

