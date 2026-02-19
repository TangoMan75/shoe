#!/bin/sh

## Install tools
##
## {
##   "namespace": "install",
##   "requires": [
##     "python3"
##   ],
##   "depends": [
##     "alert_info"
##   ]
## }
install() {
    for _file in \
        shoemaker.py \
    ; do
        _echo_info "python3 \"${_file}\" self-install\n"
        python3 "${_file}" self-install
    done
}

