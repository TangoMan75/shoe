#!/bin/sh

# Update .git/hooks folder
#
# {
#   "namespace": "git",
#   "requires": [
#     "git"
#   ],
#   "depends": [
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "SOURCE",
#       "type": "folder",
#       "description": "The source directory.",
#       "nullable": false
#     }
#   ]
# }
_git_hooks() {
    # Synopsis: _git_hooks <SOURCE>
    #   SOURCE: The source directory.

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then echo_danger 'error: not a git repository (or any of the parent directories)\n'; return 1; fi
    if [ -z "$1" ]; then echo_danger 'error: _git_hooks: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then echo_danger "error: _git_hooks: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "${1:-.githooks}")" '.git/hooks'
    if [ ! -d "$1" ]; then echo_danger "error: _git_hooks: \"$1\" folder not found\n"; return 1; fi

    echo_info "rm -rf \"$2\"\n"
    rm -rf "$2"

    echo_info "cp -r \"$1\" \"$2\"\n"
    cp -r "$1" "$2"

    echo_info "chmod +x \"$2\"/*\n"
    chmod +x "$2"/*
}

