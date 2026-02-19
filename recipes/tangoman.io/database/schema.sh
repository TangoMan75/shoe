#!/bin/sh

## Create schema
##
## {
##   "namespace": "database",
##   "depends": [
##     "_echo_info"
##   ]
## }
schema() {
    _echo_info "./bin/console doctrine:schema:create --dump-sql --env ${env}\n"
    ./bin/console doctrine:schema:create --dump-sql --env ${env}

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:schema:create --env ${env} || true\n"
    ./bin/console doctrine:schema:create --env ${env} || true
}

