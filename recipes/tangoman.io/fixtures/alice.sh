#!/bin/sh

## Load Alice fixtures
##
## {
##   "namespace": "fixtures",
##   "depends": [
##     "_echo_info"
##   ]
## }
alice() {
    _echo_info "./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}\n"
    ./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}
}

