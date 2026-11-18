#!/bin/sh

## Format a commit subject
##
## Formats a commit subject by removing type, scope, ticket, and PR
## number prefixes, then trimming whitespace.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <SUBJECT> (required) The commit subject to format.
_format_commit_subject() {
    printf '%s' "$1" \
        | sed -e 's/^[a-z()_]\{1,\}!\{0,1\}: //' \
        | sed -e 's/([A-Z]\{1,\}-[0-9]\{1,\})//g' \
        | sed -e 's/(#[0-9]\{1,\})//g' \
        | tr -s ' ' \
        | sed -e 's/ *$//'
}

