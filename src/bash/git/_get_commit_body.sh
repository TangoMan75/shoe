#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Get commit body",
##   "description": "Get the commit body from the current HEAD commit.",
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/strings/_trim"
##   ],
##   "requires": [
##     "command",
##     "git"
##   ]
## }
function _get_commit_body() {
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

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _trim "$(git --no-pager log -1 --pretty="format:%b")"
}
