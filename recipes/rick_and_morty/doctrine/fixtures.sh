#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/doctrine",
##   "summary": "Load fixtures",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
fixtures() {
    _echo_info "./bin/console doctrine:fixtures:load --no-interaction --env ${env}\n"
    ./bin/console doctrine:fixtures:load --no-interaction --env ${env}
}

