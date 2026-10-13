#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Check if a git branch name is valid",
##   "description": "Check if a git branch name is valid (alphanumeric, slash, underscore and dash characters only).",
##   "requires": [
##     "echo",
##     "false",
##     "true"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "BRANCH",
##       "type": "str",
##       "description": "The branch name to validate.",
##       "required": true
##     }
##   ]
## }
function _check_branch_is_valid() {
    if [[ "$1" =~ ^[0-9a-zA-Z/_-]+$ ]]; then
        echo true
        return 0
    fi
    echo false
}
