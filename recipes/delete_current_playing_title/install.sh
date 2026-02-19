#!/bin/sh

## Install VLC plugin
##
## {
##   "depends": [
##     "_echo_info"
##   ]
## }
install() {
    _echo_info "cp \"${file}\" \"${destination}\"\n"
    cp "${file}" "${destination}"
}

