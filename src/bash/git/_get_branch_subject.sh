#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Get branch subject",
##   "description": "Get the subject from the current git branch, removing type and ticket from it.",
##   "requires": [
##     "HEAD",
##     "command",
##     "git"
##   ],
##   "depends": [
##     "src/bash/git/_parse_branch_subject",
##     "src/shell/colors/_echo_danger"
##   ]
## }
function _get_branch_subject() {
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

    _parse_branch_subject "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}
