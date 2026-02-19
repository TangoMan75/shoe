#!/bin/sh

## Generate migration script
##
## {
##   "namespace": "database",
##   "requires": [
##     "doctrine/orm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
migration_diff() {
    _echo_info "./bin/console doctrine:migrations:diff --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:diff --no-interaction --env ${env}
}

