#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Import SQL file(s) directly to Database",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
database_import() {
    _echo_info "./bin/console doctrine:database:import ./data/dump.sql --env ${env}\n"
    ./bin/console doctrine:database:import ./data/dump.sql --env ${env}
}

