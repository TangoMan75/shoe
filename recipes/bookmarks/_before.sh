#!/bin/sh

## Prepare bookmark storage before running a command
##
## @namespace recipes/bookmarks
## @requires dirname mkdir touch
## @depends src/shell/colors/_echo_error
## @overrides src/shell/hooks/_before
## @assumes store
_before() {
    if [ -z "${store}" ]; then
        _echo_error 'error: _before: bookmark store path is empty\n'
        return 1
    fi

    __store_dir__=$(dirname "${store}")
    if [ ! -d "${__store_dir__}" ]; then
        if ! mkdir -p "${__store_dir__}"; then
            _echo_error "error: _before: cannot create \"${__store_dir__}\"\n"
            return 1
        fi
    fi

    if [ ! -f "${store}" ]; then
        if ! touch "${store}"; then
            _echo_error "error: _before: cannot create \"${store}\"\n"
            return 1
        fi
    fi
}

