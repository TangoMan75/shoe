#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse branch ticket",
##   "description": "Parse the ticket identifier from a git branch name, eg: feat/FOO-01/foobar => FOO-01.",
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
function _parse_branch_ticket() {
    echo -n "$1" | sed -nE 's/^.+\/([A-Z]+-[0-9]+)\/.+/\1/p'
}
