#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/git",
##   "summary": "Amend last commit message, author and date",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "recipes/bash_aliases/git/conventional-commit",
##     "src/shell/colors/_echo_info"
##   ]
## }
function amend() {
    if [ $# -eq 0 ]; then
        _echo_info 'git commit --amend --no-edit\n'
        git commit --amend --no-edit
    else
        conventional-commit -X "$@"
    fi
}
