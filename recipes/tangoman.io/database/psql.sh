#!/bin/sh

## Enter Postgres terminal
##
## @namespace recipes/tangoman.io/database
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
psql() {
    _check_installed psql

    _echo_info 'psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password\n'
    psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password
}

