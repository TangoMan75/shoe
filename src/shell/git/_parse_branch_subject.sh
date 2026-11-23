#!/bin/sh

## Parse branch subject
##
## Parse the subject from a git branch name, removing type and ticket
## from it, eg: feat/FOO-01/foobar => foobar.
##
## @namespace src/shell/git
## @requires grep printf
## @param {str} <BRANCH> (required) The conventional branch name to parse.
_parse_branch_subject() {
    if [ "${1%%/*}" = 'build' ] \
        || [ "${1%%/*}" = 'chore' ] \
        || [ "${1%%/*}" = 'ci' ] \
        || [ "${1%%/*}" = 'docs' ] \
        || [ "${1%%/*}" = 'feat' ] \
        || [ "${1%%/*}" = 'fix' ] \
        || [ "${1%%/*}" = 'perf' ] \
        || [ "${1%%/*}" = 'refactor' ] \
        || [ "${1%%/*}" = 'style' ] \
        || [ "${1%%/*}" = 'test' ]; then
        set -- "${1#*/}"
    fi

    if printf '%s' "$1" | LC_ALL=C grep -q -x -e '[A-Z].*-[0-9].*/.*'; then
        set -- "${1#*/}"
    fi

    printf '%s' "$1"
}

