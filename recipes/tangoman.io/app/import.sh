#!/bin/sh

## Import data
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console"
##   ]
## }
import() {
    # NOTE: imports MUST run in a specific order to avoid "UNIQUE Integrity constraint violation"
    for _item in \
        categories \
        organizations \
        people \
        skills \
        certificates \
        experiences \
        portfolio_items \
        study \
    ; do
        if [ -f ./assets/imports/${_item}.json ]; then

            _echo_info "$(_console) app:import -f ${_item}.json --env ${env}\n"
            $(_console) app:import -f ${_item}.json --env ${env}

        elif [ -f ./assets/imports/${_item}.csv ]; then

            _echo_info "$(_console) app:import -f ${_item}.csv --env ${env}\n"
            $(_console) app:import -f ${_item}.csv --env ${env}
        fi
    done

    _echo_info "$(_console) app:import -f diplomas.csv -x certificate:csv --env ${env}\n"
    $(_console) app:import -f diplomas.csv -x certificate:csv --env ${env}
}

