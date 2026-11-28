#!/bin/bash

## Write changes to local repository
##
## @namespace recipes/bash_aliases/git
## @requires echo false true
## @depends recipes/bash_aliases/git/branch.sh
## @depends recipes/bash_aliases/git/conventional-commit.sh
## @depends recipes/bash_aliases/git/guser.sh
## @depends recipes/bash_aliases/git/lremote.sh
## @flag <interactive> [-i] Skip context infos prompt.
function commit() {
    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    interactive=false

    #--------------------------------------------------

    while getopts :i option; do
        case "${option}" in
            i) interactive=true;;
            *) true;;
        esac
    done

    #--------------------------------------------------

    if [ "${interactive}" = false ]; then
        guser
        echo
        lremote
        branch -l
        echo
    fi

    #--------------------------------------------------

    conventional-commit "$@"
}

