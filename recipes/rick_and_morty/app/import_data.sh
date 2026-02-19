#!/bin/sh

## Import data
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console",
##     "_echo_info"
##   ]
## }
import_data() {
    for file in \
        data/characters.json \
        data/locations.json \
        data/episodes.json \
    ; do
        _echo_info "$(_console) app:import ${file}\n"
        $(_console) app:import ${file}
    done
}

