#!/bin/sh

## Import SQL file(s) directly to Database
database_import() {
    echo_info "./bin/console doctrine:database:import ./data/dump.sql --env ${env}\n"
    ./bin/console doctrine:database:import ./data/dump.sql --env ${env}
}

