#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Check if a commit hash is valid",
##   "requires": [
##     "echo",
##     "false",
##     "true"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "COMMIT",
##       "type": "str",
##       "description": "The commit hash to validate.",
##       "required": true
##     }
##   ]
## }
function _check_commit_is_valid() {
    if [[ "$1" =~ ^([0-9a-f]+|HEAD)(~[0-9]+)?$ ]]; then
        echo true
        return 0
    fi
    echo false
}
