#!/bin/sh

## Show a bookmark
##
## @namespace recipes/bookmarks
## @depends recipes/bookmarks/_get_url src/shell/colors/_echo_error src/shell/colors/_echo_primary src/shell/colors/_echo_success
## @assumes name
## @example bookmarks show --name shoe
## @stdout the bookmark name and URL
## @option {str} <name> [-n|--name] /^[A-Za-z0-9._-]+$/ (default:"") Bookmark name
show() {
    if [ -z "${name}" ]; then
        _echo_error 'error: show: "--name" is required\n'
        return 1
    fi

    __url__=$(_get_url "${name}")
    if [ -z "${__url__}" ]; then
        _echo_error "error: show: bookmark \"${name}\" not found\n"
        return 1
    fi

    _echo_success 'name' 2 8; _echo_primary "${name}\n"
    _echo_success 'url' 2 8; _echo_primary "${__url__}\n"
}

