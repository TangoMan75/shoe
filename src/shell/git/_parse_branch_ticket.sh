#!/bin/sh

## Parse branch ticket
##
## Parse the ticket identifier from a git branch name,
## eg: feat/FOO-01/foobar => FOO-01.
##
## @namespace src/shell/git
## @requires printf sed
## @param {str} <BRANCH> (required) The conventional branch name to parse.
_parse_branch_ticket() {
    printf '%s' "$1" | sed -n 's/^.*\/\([A-Z]\{1,\}-[0-9]\{1,\}\)\/.*$/\1/p'
}

