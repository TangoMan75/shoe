#!/bin/sh

## Format a commit subject
##
## Formats a commit subject by removing type, scope, ticket, and PR number prefixes, then trimming whitespace.
##
## @namespace src/bash/git
## @requires echo sed tr
## @param {str} <SUBJECT> (required) The commit subject to format.
_format_commit_subject() {
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#[0-9]+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}

