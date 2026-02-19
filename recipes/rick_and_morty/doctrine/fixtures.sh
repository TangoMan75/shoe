#!/bin/sh

## Load fixtures
##
## {
##   "namespace": "fixtures",
##   "requires": [
##     "doctrine/orm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
fixtures() {
    _echo_info "./bin/console doctrine:fixtures:load --no-interaction --env ${env}\n"
    ./bin/console doctrine:fixtures:load --no-interaction --env ${env}
}
