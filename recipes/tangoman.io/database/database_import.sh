#!/bin/sh

## Import SQL file(s) directly to Database
##
## @namespace recipes/tangoman.io/database
## @depends src/shell/colors/_echo_info
## @assumes env
database_import() {
    _echo_info "./bin/console doctrine:database:import ./data/dump.sql --env ${env}\n"
    ./bin/console doctrine:database:import ./data/dump.sql --env ${env}
}

