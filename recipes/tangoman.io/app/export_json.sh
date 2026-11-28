#!/bin/sh

## Export data in json
##
## @namespace recipes/tangoman.io/app
## @requires skill
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/symfony/_console.sh
## @assumes env
export_json() {
    for _item in \
        article \
        bookmark \
        category \
        certificate \
        event \
        experience \
        organization \
        person \
        portfolio_item \
        postal_address \
        skill \
        study \
        tag \
    ; do
        # `-x` encoder `-g` group
        _echo_info "$(_console) app:export -x ${_item}:json -g read:${_item} --env \"${env}\"\n"
        $(_console) app:export -x ${_item}:json -g read:${_item} --env "${env}"
    done
}

