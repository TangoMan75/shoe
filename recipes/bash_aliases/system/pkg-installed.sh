#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/system",
##   "summary": "Find / list installed apt packages",
##   "requires": [
##     "apt"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_info"
##   ]
## }
function pkg-installed() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'apt list --installed\n'
    apt list --installed
}
