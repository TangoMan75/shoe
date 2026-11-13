#!/bin/sh

## Load fixtures (doctrine)
##
## @namespace recipes/tangoman.io/fixtures
## @depends src/shell/colors/_echo_info
## @assumes env
fixtures() {
    _echo_info "./bin/console doctrine:fixtures:load --no-interaction --env ${env}\n"
    ./bin/console doctrine:fixtures:load --no-interaction --env ${env}
}

