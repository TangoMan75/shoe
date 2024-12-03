#!/bin/sh

## Drop database
drop() {
    # following command will not break script execution on failure even with `-e` option enabled
    echo_info "./bin/console doctrine:database:drop --force --env ${env} || true\n"
    ./bin/console doctrine:database:drop --force --env ${env} || true
}

