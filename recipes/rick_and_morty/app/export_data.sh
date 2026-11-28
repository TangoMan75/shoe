#!/bin/sh

## Export data
##
## @namespace recipes/rick_and_morty/app
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/symfony/_console.sh
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

