#!/bin/sh

## Export data in csv
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console"
##   ]
## }
export_csv() {
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
        _echo_info "$(_console) app:export -x ${_item}:csv -g read:${_item} --env ${env}\n"
        $(_console) app:export -x ${_item}:csv -g read:${_item} --env ${env}
    done
}

