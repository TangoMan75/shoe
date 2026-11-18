#!/bin/sh

## Parse commit type
##
## Parse the commit type from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => feat.
##
## @namespace src/shell/git
## @requires awk printf
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_type() {
    printf '%s' "$1" | awk -F '[^a-z_]' '/^[a-z()_]*!?: /{print $1}'
}

