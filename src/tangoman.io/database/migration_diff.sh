#!/bin/sh

## Generate migration script
migration_diff() {
    echo_info "./bin/console doctrine:migrations:diff --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:diff --no-interaction --env ${env}
}

