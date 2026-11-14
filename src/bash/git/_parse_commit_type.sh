#!/bin/bash

## Parse commit type
##
## Parse the commit type from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) => feat.
##
## @namespace src/bash/git
## @requires awk echo
function _parse_commit_type() {
    echo -n "$1" | awk -F '[^a-z_]' '/^[a-z()_]*!?: /{print $1}'
}

