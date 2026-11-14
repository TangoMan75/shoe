#!/bin/bash

## Parse the subject from a git branch name, removing type and ticket from it, eg: feat/FOO-01/foobar => foobar.
##
## @namespace src/bash/git
## @requires echo sed
## @param {str} <BRANCH> (required) The conventional branch name to parse.
function _parse_branch_subject() {
    # remove type and ticket from subject
    echo -n "$1" | sed -E 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\///' | sed -E 's/[A-Z]+-[0-9]+\///'
}

