#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/git",
##   "summary": "Write changes to local repository",
##   "requires": [
##     "echo",
##     "false",
##     "true"
##   ],
##   "depends": [
##     "recipes/bash_aliases/git/branch",
##     "recipes/bash_aliases/git/conventional-commit",
##     "recipes/bash_aliases/git/guser",
##     "recipes/bash_aliases/git/lremote"
##   ],
##   "flags": [
##     {
##       "name": "interactive",
##       "description": "Skip context infos prompt.",
##       "short": "i"
##     }
##   ]
## }
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

