#!/bin/sh

## Truncate table
truncate() {
    if [ -z "${table}" ]; then
        echo_error '"table" cannot be empty\n'
        return 1
    fi

    if [ "$(_get_database_type)" = sqlite ]; then
        echo_info "./bin/console doctrine:query:sql \"DELETE FROM \`${table}\`\" --env ${env}\n"
        ./bin/console doctrine:query:sql "DELETE FROM \`${table}\`" --env ${env}

        echo_info "./bin/console doctrine:query:sql 'VACUUM' --env ${env}\n"
        ./bin/console doctrine:query:sql 'VACUUM' --env ${env}
    else
        echo_info "./bin/console doctrine:query:sql \"TRUNCATE TABLE \`${table}\`\" --env ${env}\n"
        ./bin/console doctrine:query:sql "TRUNCATE TABLE \`${table}\`" --env ${env}
    fi
}

