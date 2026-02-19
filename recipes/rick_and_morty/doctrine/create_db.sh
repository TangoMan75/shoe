#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/doctrine",
##   "summary": "Create database",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
create_db() {
    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:database:create --env ${env} || true\n"
    ./bin/console doctrine:database:create --env ${env} || true
}

