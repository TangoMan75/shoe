#!/bin/sh

## Truncate table
##
## {
##   "namespace": "database",
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_get_database_type"
##   ]
## }
truncate() {
    if [ -z "${table}" ]; then
        _echo_error '"table" cannot be empty\n'
        return 1
    fi

    if [ "$(_get_database_type)" = sqlite ]; then
        _echo_info "./bin/console doctrine:query:sql \"DELETE FROM \`${table}\`\" --env ${env}\n"
        ./bin/console doctrine:query:sql "DELETE FROM \`${table}\`" --env ${env}

        _echo_info "./bin/console doctrine:query:sql 'VACUUM' --env ${env}\n"
        ./bin/console doctrine:query:sql 'VACUUM' --env ${env}
    else
        _echo_info "./bin/console doctrine:query:sql \"TRUNCATE TABLE \`${table}\`\" --env ${env}\n"
        ./bin/console doctrine:query:sql "TRUNCATE TABLE \`${table}\`" --env ${env}
    fi
}

