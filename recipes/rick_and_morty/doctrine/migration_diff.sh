#!/bin/sh

## Generate migration script
##
## @namespace recipes/rick_and_morty/doctrine
## @requires diff
## @depends src/shell/colors/_echo_info
## @assumes env
migration_diff() {
    _echo_info "./bin/console doctrine:migrations:diff --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:diff --no-interaction --env ${env}
}

