#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Enter Postgres terminal",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
psql() {
    _check_installed psql

    _echo_info 'psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password\n'
    psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password
}

