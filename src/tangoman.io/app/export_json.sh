#!/bin/sh

## Export data in json
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
        echo_info "./bin/console app:export -x ${_item}:json -g read:${_item} --env ${env}\n"
        ./bin/console app:export -x ${_item}:json -g read:${_item} --env ${env}
    done
}

