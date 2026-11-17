#!/bin/sh

## Search bookmarks
##
## @namespace recipes/bookmarks
## @depends recipes/bookmarks/_list_rows
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @assumes __count__
## @example bookmarks search --term github
## @stdout the matching bookmark rows
## @option {str} <term> [-t|--term] (default:"") Search term
search() {
    if [ -z "${term}" ]; then
        _echo_error 'error: search: "--term" is required\n'
        return 1
    fi

    _list_rows "${term}"

    if [ "${__count__}" -eq 0 ]; then
        _echo_info "No bookmarks matching \"${term}\".\n"
    fi
}

