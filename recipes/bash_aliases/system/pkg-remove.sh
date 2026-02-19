#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/system",
##   "summary": "Shortcut for apt-get remove -y",
##   "requires": [
##     "apt-get",
##     "sudo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_info"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "package",
##       "description": "Package name to remove.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
function pkg-remove() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "sudo apt-get remove -y \"$1\"\n"
    # shellcheck disable=SC2033
    sudo apt-get remove -y "$1"
}

