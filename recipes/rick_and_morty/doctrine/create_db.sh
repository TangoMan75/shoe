#!/bin/sh

## Create database
##
## @namespace recipes/rick_and_morty/doctrine
## @requires true
## @depends src/shell/colors/_echo_info
## @assumes env
create_db() {
    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:database:create --env ${env} || true\n"
    ./bin/console doctrine:database:create --env ${env} || true
}

