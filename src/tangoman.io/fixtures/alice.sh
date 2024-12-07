#!/bin/sh

## Load Alice fixtures
alice() {
    echo_info "./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}\n"
    ./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}
}

