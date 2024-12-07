#!/bin/sh

## Load fixtures (doctrine)
fixtures() {
    echo_info "./bin/console doctrine:fixtures:load --no-interaction --env ${env}\n"
    ./bin/console doctrine:fixtures:load --no-interaction --env ${env}
}

