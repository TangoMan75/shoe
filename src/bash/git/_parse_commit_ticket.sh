#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse commit ticket",
##   "description": "Parse the ticket identifier from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) => FOO-01.",
##   "requires": [
##     "echo",
##     "sed"
##   ]
## }
function _parse_commit_ticket() {
    echo -n "$1" | sed -nE 's/.*\(([A-Z]+-[0-9]+)\).*/\1/p'
}
