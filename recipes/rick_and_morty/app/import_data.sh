#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/app",
##   "summary": "Import data",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
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

