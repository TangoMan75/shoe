#!/bin/sh

## Load fixtures
##
## @namespace recipes/rick_and_morty/doctrine
## @depends src/shell/colors/_echo_info
## @assumes env
fixtures() {
    _echo_info "./bin/console doctrine:fixtures:load --no-interaction --env ${env}\n"
    ./bin/console doctrine:fixtures:load --no-interaction --env ${env}
}

