#!/bin/bash

## Parse branch type
##
## Parse the conventional type from a git branch name, eg: feat/FOO-01/foobar => feat.
##
## @namespace src/bash/git
## @requires echo sed
## @param {str} <BRANCH> (required) The conventional branch name to parse.
function _parse_branch_type() {
    echo -n "$1" | sed -nE 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\/.+/\1/p'
}

