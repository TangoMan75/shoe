#!/bin/sh

## List bookmarks
##
## @namespace recipes/bookmarks
## @depends recipes/bookmarks/_list_rows src/shell/colors/_echo_info
## @assumes __count__
## @example bookmarks list
## @example bookmarks list --output csv
## @stdout the bookmark list
list() {
    _list_rows ''

    if [ "${__count__}" -eq 0 ]; then
        _echo_info 'No bookmarks found.\n'
    fi
}

