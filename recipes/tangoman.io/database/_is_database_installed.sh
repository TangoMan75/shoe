#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Check if database is installed",
##   "requires": [
##     "echo",
##     "false",
##     "true"
##   ],
##   "depends": [
##     "recipes/tangoman.io/database/_get_database_type"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
_is_database_installed() {
    if [ "$(_get_database_type)" = sqlite ] && [ -f ./var/data_${env}.db ]; then
        echo true
        return 0
    fi

    echo false
}

