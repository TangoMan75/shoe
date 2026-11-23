#!/bin/sh

## Check if a commit hash is valid
##
## @namespace src/shell/git
## @requires printf tr
## @param {str} <COMMIT> (required) The commit hash to validate.
_check_commit_is_valid() {
    if [ "$1" = 'HEAD' ]; then
        printf 'true\n'

        return 0
    fi
    if [ "${1#HEAD~}" != "$1" ] \
        && [ -n "${1#HEAD~}" ] \
        && [ -z "$(printf '%s' "${1#HEAD~}" | LC_ALL=C tr -d '0-9')" ]; then
        printf 'true\n'

        return 0
    fi
    if [ -z "$1" ] \
        || [ -n "$(printf '%s' "$1" | LC_ALL=C tr -d '0-9a-f')" ]; then
        printf 'false\n'

        return 0
    fi

    printf 'true\n'
}

