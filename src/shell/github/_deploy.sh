#!/bin/sh

## Deploy source folder to "gh-pages"
##
## @namespace src/shell/github
## @requires HEAD git split
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @param {folder} <SOURCE> (required) The source directory.
_deploy() {
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi
    if [ -z "$1" ]; then _echo_error '_deploy: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_deploy: too many arguments ($#)\n"; return 1; fi
    if [ ! -d "$1" ]; then _echo_error "_deploy: \"$1\" folder not found\n"; return 1; fi

    # An empty source in a refspec means "delete this remote ref": the
    # split result is checked before anything is pushed.
    __sha__="$(git subtree split --prefix "$1" HEAD 2>/dev/null)"
    if [ -z "${__sha__}" ]; then
        _echo_error "_deploy: no commit history for \"$1\" on HEAD\n"

        return 1
    fi

    _echo_info "git push origin \"${__sha__}\":refs/heads/gh-pages --force\n"
    git push origin "${__sha__}":refs/heads/gh-pages --force
}

