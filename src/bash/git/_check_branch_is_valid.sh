#!/bin/bash

## Check if a git branch name is valid
##
## Check if a git branch name is valid (alphanumeric, slash, underscore and dash characters only).
##
## @namespace src/bash/git
## @requires echo false true
## @param {str} <BRANCH> (required) The branch name to validate.
function _check_branch_is_valid() {
    if [[ "$1" =~ ^[0-9a-zA-Z/_-]+$ ]]; then
        echo true
        return 0
    fi
    echo false
}

