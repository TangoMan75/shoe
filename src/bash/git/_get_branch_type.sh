#!/bin/bash

## {
##   "summary": "Get branch type",
##   "description": "Get the conventional type from the current git branch.",
##   "namespace": "src/bash/git",
##   "requires": [
##     "HEAD",
##     "command",
##     "git"
##   ],
##   "depends": [
##     "src/bash/git/_parse_branch_type",
##     "src/shell/colors/_echo_danger"
##   ]
## }
function _get_branch_type() {
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

    _parse_branch_type "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}
