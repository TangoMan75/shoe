#!/bin/sh

## Export data
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console",
##     "_echo_info"
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

