#!/bin/sh

## Deploy source folder to "gh-pages"
##
## {
##   "namespace": "github",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SOURCE",
##       "type": "folder",
##       "description": "The source directory.",
##       "nullable": false
##     }
##   ]
## }
_deploy() {
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi
    if [ -z "$1" ]; then _echo_error '_deploy: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_deploy: too many arguments ($#)\n"; return 1; fi
    if [ ! -d "$1" ]; then _echo_error "_deploy: \"$1\" folder not found\n"; return 1; fi

    # `git subtree split --prefix dist main`: create a temporary commit history from the "dist" subdirectory of the "main" branch.
    _echo_info "git push origin \"\$(git subtree split --prefix \"$1\" HEAD)\":refs/heads/gh-pages --force\n"
    git push origin "$(git subtree split --prefix "$1" HEAD)":refs/heads/gh-pages --force
}
