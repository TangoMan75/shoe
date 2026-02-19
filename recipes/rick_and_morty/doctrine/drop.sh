#!/bin/sh

## Drop database
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
drop() {
    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:database:drop --force --env ${env} || true\n"
    ./bin/console doctrine:database:drop --force --env ${env} || true
}

