#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/system",
##   "summary": "Find / list available apt packages",
##   "requires": [
##     "apt",
##     "apt-cache",
##     "sort"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_info"
##   ]
## }
function pkg-list() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'apt-cache pkgnames | sort\n'
    apt-cache pkgnames | sort
}
