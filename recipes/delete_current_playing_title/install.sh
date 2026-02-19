#!/bin/sh

## {
##   "namespace": "recipes/delete_current_playing_title",
##   "summary": "Install VLC plugin",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
install() {
    _echo_info "cp \"${file}\" \"${destination}\"\n"
    cp "${file}" "${destination}"
}

