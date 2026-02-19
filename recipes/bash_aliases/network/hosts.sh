#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/network",
##   "summary": "Edit hosts with default text editor",
##   "requires": [
##     "sudo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_info"
##   ],
##   "assumes": [
##     "VISUAL"
##   ]
## }
function hosts() {
    #--------------------------------------------------
    # Check default text editor
    #--------------------------------------------------

    if [ ! -x "${VISUAL}" ]; then
        _echo_danger "error: cannot open ${VISUAL}\n"
        return 1
    fi

    #--------------------------------------------------

    _echo_info "sudo \"${VISUAL}\" /etc/hosts\n"
    sudo "${VISUAL}" /etc/hosts
}

