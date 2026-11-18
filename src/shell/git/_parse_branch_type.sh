#!/bin/sh

## Parse branch type
##
## Parse the conventional type from a git branch name,
## eg: feat/FOO-01/foobar => feat.
##
## @namespace src/shell/git
## @requires printf
## @param {str} <BRANCH> (required) The conventional branch name to parse.
_parse_branch_type() {
    if [ "${1#*/}" = "$1" ]; then

        return 0
    fi

    if [ "${1%%/*}" = 'build' ]; then
        printf 'build'
    elif [ "${1%%/*}" = 'chore' ]; then
        printf 'chore'
    elif [ "${1%%/*}" = 'ci' ]; then
        printf 'ci'
    elif [ "${1%%/*}" = 'docs' ]; then
        printf 'docs'
    elif [ "${1%%/*}" = 'feat' ]; then
        printf 'feat'
    elif [ "${1%%/*}" = 'fix' ]; then
        printf 'fix'
    elif [ "${1%%/*}" = 'perf' ]; then
        printf 'perf'
    elif [ "${1%%/*}" = 'refactor' ]; then
        printf 'refactor'
    elif [ "${1%%/*}" = 'style' ]; then
        printf 'style'
    elif [ "${1%%/*}" = 'test' ]; then
        printf 'test'
    fi
}

