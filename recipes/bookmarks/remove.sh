#!/bin/sh

## Remove a bookmark
##
## @namespace recipes/bookmarks
## @requires awk mv
## @depends recipes/bookmarks/_get_url src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/colors/_echo_success src/shell/prompts/_yes_no
## @assumes force name store verbose
## @example bookmarks remove --name shoe --force
## @stdout the confirmation message
## @option {str} <name> [-n|--name] /^[A-Za-z0-9._-]+$/ (default:"") Bookmark name
## @flag <force> [-f|--force] Skip confirmation prompts
remove() {
    if [ -z "${name}" ]; then
        _echo_error 'error: remove: "--name" is required\n'
        return 1
    fi

    __url__=$(_get_url "${name}")
    if [ -z "${__url__}" ]; then
        _echo_error "error: remove: bookmark \"${name}\" not found\n"
        return 1
    fi

    if [ "${force}" != 'true' ]; then
        if ! _yes_no "Remove \"${name}\" ?"; then
            _echo_info 'Aborted.\n'
            return 0
        fi
    fi

    __tmp__="${store}.tmp"
    if ! awk -F '\t' -v name="${name}" '$1 != name' "${store}" > "${__tmp__}"; then
        _echo_error 'error: remove: cannot update bookmark store\n'
        return 1
    fi

    if ! mv "${__tmp__}" "${store}"; then
        _echo_error 'error: remove: cannot replace bookmark store\n'
        return 1
    fi

    if [ "${verbose}" = 'true' ]; then
        _echo_info "removed from \"${store}\"\n"
    fi

    _echo_success "Bookmark \"${name}\" removed.\n"
}

