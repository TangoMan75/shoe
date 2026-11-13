#!/bin/sh

## Install VLC plugin
##
## @namespace recipes/delete_current_playing_title
## @requires cp
## @depends src/shell/colors/_echo_info
## @assumes destination file
install() {
    _echo_info "cp \"${file}\" \"${destination}\"\n"
    cp "${file}" "${destination}"
}

