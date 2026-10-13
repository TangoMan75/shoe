#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse commit type",
##   "description": "Parse the commit type from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) => feat.",
##   "requires": [
##     "awk",
##     "echo"
##   ]
## }
function _parse_commit_type() {
    echo -n "$1" | awk -F '[^a-z_]' '/^[a-z()_]*!?: /{print $1}'
}
