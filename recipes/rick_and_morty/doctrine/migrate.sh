#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/doctrine",
##   "summary": "Execute migration",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
migrate() {
    # following command prints SQL to be executed in the command line
    _echo_info "./bin/console doctrine:migrations:migrate --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:migrate --no-interaction --env ${env}

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:schema:validate --env ${env} || true\n"
    ./bin/console doctrine:schema:validate --env ${env} || true
}

