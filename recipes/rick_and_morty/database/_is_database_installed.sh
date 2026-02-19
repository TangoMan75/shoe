#!/bin/sh

## Check if database is installed
##
## {
##   "namespace": "database",
##   "depends": [
##     "_get_database_type"
##   ]
## }
_is_database_installed() {
    if [ "$(_get_database_type)" = sqlite ] && [ -f ./var/data_${env}.db ]; then
        echo true
        return 0
    fi

    echo false
}

