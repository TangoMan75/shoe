#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Get commit type",
##   "description": "Get the commit type from the current HEAD commit.",
##   "depends": [
##     "src/bash/git/_parse_commit_type",
##     "src/shell/colors/_echo_danger"
##   ],
##   "requires": [
##     "command",
##     "echo",
##     "git"
##   ]
## }
function _get_commit_type() {
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

    local TYPE

    TYPE=$(_get_branch_type)
    if [ -n "${TYPE}" ]; then
        echo -n "${TYPE}"
        return 0
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_type "$(git --no-pager log -1 --pretty="format:%s")"
}
