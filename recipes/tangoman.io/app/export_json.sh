#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/app",
##   "summary": "Export data in json",
##   "requires": [
##     "skill"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
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
        _echo_info "$(_console) app:export -x ${_item}:json -g read:${_item} --env ${env}\n"
        $(_console) app:export -x ${_item}:json -g read:${_item} --env ${env}
    done
}

