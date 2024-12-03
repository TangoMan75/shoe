#!/bin/sh

## Export data in csv
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
        echo_info "./bin/console app:export -x ${_item}:csv -g read:${_item} --env ${env}\n"
        ./bin/console app:export -x ${_item}:csv -g read:${_item} --env ${env}
    done
}

