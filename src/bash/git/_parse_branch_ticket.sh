#!/bin/bash

## Parse branch ticket
##
## Parse the ticket identifier from a git branch name, eg: feat/FOO-01/foobar => FOO-01.
##
## @namespace src/bash/git
## @requires echo sed
## @param {str} <BRANCH> (required) The conventional branch name to parse.
function _parse_branch_ticket() {
    echo -n "$1" | sed -nE 's/^.+\/([A-Z]+-[0-9]+)\/.+/\1/p'
}

