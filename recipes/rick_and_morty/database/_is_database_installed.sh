#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/database",
##   "summary": "Check if database is installed",
##   "requires": [
##     "echo",
##     "false",
##     "true"
##   ],
##   "depends": [
##     "recipes/rick_and_morty/database/_get_database_type"
##   ]
## }
_is_database_installed() {
    if [ "$(_get_database_type)" = sqlite ] && [ -f ./var/data_${env}.db ]; then
        echo true
        return 0
    fi

    echo false
}

