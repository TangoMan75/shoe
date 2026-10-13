#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse branch ticket",
##   "description": "Parse the ticket identifier from a git branch name, eg: feat/FOO-01/foobar => FOO-01.",
##   "requires": [
##     "echo",
##     "sed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "BRANCH",
##       "description": "The conventional branch name to parse.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
function _parse_branch_ticket() {
    echo -n "$1" | sed -nE 's/^.+\/([A-Z]+-[0-9]+)\/.+/\1/p'
}
