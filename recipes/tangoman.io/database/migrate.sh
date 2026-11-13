#!/bin/sh

## Execute migration scripts
##
## @namespace recipes/tangoman.io/database
## @requires true
## @depends src/shell/colors/_echo_info
## @assumes env
migrate() {
    _echo_info "./bin/console doctrine:migrations:migrate --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:migrate --no-interaction --env ${env}

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:schema:validate --env ${env} || true\n"
    ./bin/console doctrine:schema:validate --env ${env} || true
}

