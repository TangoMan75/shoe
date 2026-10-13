#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Get branch ticket",
##   "summary": "Get the ticket identifier from the current git branch.",
##   "requires": [
##     "HEAD",
##     "command",
##     "git"
##   ],
##   "depends": [
##     "src/bash/git/_parse_branch_ticket",
##     "src/shell/colors/_echo_danger"
##   ]
## }
function _get_branch_ticket() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    _parse_branch_ticket "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}
