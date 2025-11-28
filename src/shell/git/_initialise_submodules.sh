#!/bin/sh

## Initialise git submodules
##
## {
##   "namespace": "git",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ]
## }
_initialise_submodules() {
    # Synopsis: _initialise_submodules

    _check_installed git

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi

    _echo_info 'git submodule update --init --recursive\n'
    git submodule update --init --recursive
}

