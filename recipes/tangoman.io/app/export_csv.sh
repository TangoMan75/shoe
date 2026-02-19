#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/app",
##   "summary": "Export data in csv",
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
        # `-x` encoder `-g` group
        _echo_info "$(_console) app:export -x ${_item}:csv -g read:${_item} --env ${env}\n"
        $(_console) app:export -x ${_item}:csv -g read:${_item} --env ${env}
    done
}

