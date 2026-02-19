#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/doctrine",
##   "summary": "Create schema with Doctrine",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
schema() {
    # following command prints SQL to be executed in the terminal
    _echo_info "./bin/console doctrine:schema:create --dump-sql --env ${env}\n"
    ./bin/console doctrine:schema:create --dump-sql --env ${env}

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:schema:create --env ${env} || true\n"
    ./bin/console doctrine:schema:create --env ${env} || true
}

