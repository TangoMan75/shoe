#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse commit subject",
##   "description": "Parse the commit subject from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) => FooBar.",
##   "requires": [
##     "echo",
##     "sed",
##     "tr"
##   ]
## }
function _parse_commit_subject() {
    # remove type ,scope, ticket and pull request from subject
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#\d+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}
