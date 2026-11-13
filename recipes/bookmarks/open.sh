#!/bin/sh

## Open a bookmark in the default browser
##
## @namespace recipes/bookmarks
## @requires nohup
## @depends recipes/bookmarks/_get_url src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_open
## @assumes name verbose
## @example bookmarks open --name shoe
## @stderr error messages
## @option {str} <name> [-n|--name] /^[A-Za-z0-9._-]+$/ (default:"") Bookmark name
open() {
    if [ -z "${name}" ]; then
        _echo_error 'error: open: "--name" is required\n'
        return 1
    fi

    __url__=$(_get_url "${name}")
    if [ -z "${__url__}" ]; then
        _echo_error "error: open: bookmark \"${name}\" not found\n"
        return 1
    fi

    __opener__=$(_open)
    if [ "${verbose}" = 'true' ]; then
        _echo_info "nohup \"${__opener__}\" \"${__url__}\" >/dev/null 2>&1\n"
    fi
    nohup "${__opener__}" "${__url__}" >/dev/null 2>&1
}

