#!/bin/sh

## Check if a git branch name is valid
##
## Check if a git branch name is valid (alphanumeric, slash, underscore
## and dash characters only).
##
## @namespace src/shell/git
## @requires printf tr
## @param {str} <BRANCH> (required) The branch name to validate.
_check_branch_is_valid() {
    if [ -z "$1" ] \
        || [ -n "$(printf '%s' "$1" | LC_ALL=C tr -d '[:alnum:]/_-')" ]; then
        printf 'false\n'
    else
        printf 'true\n'
    fi
}

