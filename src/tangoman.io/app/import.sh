#!/bin/sh

## Import data
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

            echo_info "./bin/console app:import -f ${_item}.json --env ${env}\n"
            ./bin/console app:import -f ${_item}.json --env ${env}

        elif [ -f ./assets/imports/${_item}.csv ]; then

            echo_info "./bin/console app:import -f ${_item}.csv --env ${env}\n"
            ./bin/console app:import -f ${_item}.csv --env ${env}
        fi
    done

    echo_info "./bin/console app:import -f diplomas.csv -x certificate:csv --env ${env}\n"
    ./bin/console app:import -f diplomas.csv -x certificate:csv --env ${env}
}

