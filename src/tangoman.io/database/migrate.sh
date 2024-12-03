#!/bin/sh

## Execute migration scripts
migrate() {
    echo_info "./bin/console doctrine:migrations:migrate --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:migrate --no-interaction --env ${env}

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info "./bin/console doctrine:schema:validate --env ${env} || true\n"
    ./bin/console doctrine:schema:validate --env ${env} || true
}

