#!/bin/bash

## Parse commit pull request number
##
## Parse the pull request number from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) (#4321) => 4321.
##
## @namespace src/bash/git
## @requires echo sed
function _parse_commit_pull_request() {
    echo -n "$1" | sed -nE 's/.*\(#([0-9]+)\).*/\1/p'
}

