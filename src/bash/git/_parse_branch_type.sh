#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse branch type",
##   "description": "Parse the conventional type from a git branch name, eg: feat/FOO-01/foobar => feat.",
##   "requires": [
##     "echo",
##     "sed"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "BRANCH",
##       "type": "str",
##       "description": "The conventional branch name to parse.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _parse_branch_type() {
    echo -n "$1" | sed -nE 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\/.+/\1/p'
}
