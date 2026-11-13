#!/bin/sh

## Print the URL of a bookmark by name
##
## @namespace recipes/bookmarks
## @requires awk
## @depends src/shell/colors/_echo_error
## @assumes store
## @stdout the matching bookmark URL, or nothing when not found
## @param {str} <NAME> (required) The bookmark name.
_get_url() {
    if [ -z "$1" ]; then _echo_error '_get_url: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_url: too many arguments ($#)\n"; return 1; fi

    awk -F '\t' -v name="$1" '$1 == name { print $2; exit }' "${store}"
}

