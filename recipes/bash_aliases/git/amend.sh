#!/bin/bash

## Amend last commit message, author and date
##
## @namespace recipes/bash_aliases/git
## @requires git
## @depends recipes/bash_aliases/git/conventional-commit src/shell/colors/_echo_info
function amend() {
    if [ $# -eq 0 ]; then
        _echo_info 'git commit --amend --no-edit\n'
        git commit --amend --no-edit
    else
        conventional-commit -X "$@"
    fi
}

