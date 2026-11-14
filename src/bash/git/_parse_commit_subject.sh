#!/bin/bash

## Parse commit subject
##
## Parse the commit subject from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) => FooBar.
##
## @namespace src/bash/git
## @requires echo sed tr
function _parse_commit_subject() {
    # remove type ,scope, ticket and pull request from subject
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#[0-9]+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}

