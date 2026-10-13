#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse the subject from a git branch name, removing type and ticket from it, eg: feat/FOO-01/foobar => foobar.",
##   "requires": [
##     "echo",
##     "sed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "BRANCH",
##       "type": "str",
##       "description": "The conventional branch name to parse.",
##       "required": true
##     }
##   ]
## }
function _parse_branch_subject() {
    # remove type and ticket from subject
    echo -n "$1" | sed -E 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\///' | sed -E 's/[A-Z]+-[0-9]+\///'
}
