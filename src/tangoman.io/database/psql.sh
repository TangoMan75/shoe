#!/bin/sh

## Enter Postgres terminal
psql() {
    _check_installed psql

    echo_info 'psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password\n'
    psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password
}

