#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/fixtures",
##   "summary": "Load Alice fixtures",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
alice() {
    _echo_info "./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}\n"
    ./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}
}

