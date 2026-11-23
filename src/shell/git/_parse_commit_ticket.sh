#!/bin/sh

## Parse commit ticket
##
## Parse the ticket identifier from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => FOO-01.
##
## @namespace src/shell/git
## @requires printf sed
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_ticket() {
    printf '%s' "$1" | sed -n 's/.*(\([A-Z]\{1,\}-[0-9]\{1,\}\)).*/\1/p'
}

