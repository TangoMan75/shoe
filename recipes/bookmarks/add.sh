#!/bin/sh

## Add a bookmark
##
## @namespace recipes/bookmarks
## @requires printf
## @depends recipes/bookmarks/_get_url src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/colors/_echo_success
## @assumes name store url verbose
## @example bookmarks add --name shoe --url https://github.com/TangoMan75/shoe
## @stdout the confirmation message
## @option {str} <name> [-n|--name] /^[A-Za-z0-9._-]+$/ (default:"") Bookmark name
## @option {str} <url> [-u|--url] /^https?://[^[:space:]]+$/ (default:"") Bookmark URL
add() {
    if [ -z "${name}" ] || [ -z "${url}" ]; then
        _echo_error 'error: add: "--name" and "--url" are required\n'
        return 1
    fi

    __url__=$(_get_url "${name}")
    if [ -n "${__url__}" ]; then
        _echo_error "error: add: bookmark \"${name}\" already exists\n"
        return 1
    fi

    printf '%s\t%s\n' "${name}" "${url}" >> "${store}"

    if [ "${verbose}" = 'true' ]; then
        _echo_info "stored in \"${store}\"\n"
    fi

    _echo_success "Bookmark \"${name}\" added.\n"
}

