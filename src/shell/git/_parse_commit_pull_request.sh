#!/bin/sh

## Parse commit pull request number
##
## Parse the pull request number from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) (#4321) => 4321.
##
## @namespace src/shell/git
## @requires printf sed
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_pull_request() {
    printf '%s' "$1" | sed -n 's/.*(#\([0-9]\{1,\}\)).*/\1/p'
}

