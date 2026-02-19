#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/app",
##   "summary": "Export data",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ]
## }
export_data() {
    for entity in \
        Character \
        Location \
        Episode \
    ; do
        _echo_info "$(_console) app:export ${entity}\n"
        $(_console) app:export ${entity}
    done
}

