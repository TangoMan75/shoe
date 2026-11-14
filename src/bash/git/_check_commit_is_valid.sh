#!/bin/bash

## Check if a commit hash is valid
##
## @namespace src/bash/git
## @requires HEAD echo
## @param {str} <COMMIT> (required) The commit hash to validate.
function _check_commit_is_valid() {
    if [[ "$1" =~ ^([0-9a-f]+|HEAD)(~[0-9]+)?$ ]]; then
        echo 'true'
        return 0
    fi
    echo 'false'
}

