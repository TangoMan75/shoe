#!/bin/sh

## Parse commit subject
##
## Parse the commit subject from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => FooBar.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_subject() {
    # remove type, scope, ticket and pull request from subject
    printf '%s' "$1" \
        | sed -e 's/^[a-z()_]\{1,\}!\{0,1\}: //' \
        | sed -e 's/([A-Z]\{1,\}-[0-9]\{1,\})//g' \
        | sed -e 's/(#[0-9]\{1,\})//g' \
        | tr -s ' ' \
        | sed -e 's/ *$//'
}

