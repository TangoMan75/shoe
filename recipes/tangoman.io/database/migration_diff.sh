#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Generate migration script",
##   "requires": [
##     "diff"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
migration_diff() {
    _echo_info "./bin/console doctrine:migrations:diff --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:diff --no-interaction --env ${env}
}

