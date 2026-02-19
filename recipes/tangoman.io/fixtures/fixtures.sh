#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/fixtures",
##   "summary": "Load fixtures (doctrine)",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
fixtures() {
    _echo_info "./bin/console doctrine:fixtures:load --no-interaction --env ${env}\n"
    ./bin/console doctrine:fixtures:load --no-interaction --env ${env}
}

