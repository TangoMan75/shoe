#!/bin/sh

## Clear cache
cache() {
    echo_info "php -d memory_limit=-1 ./bin/console cache:clear --env ${env}\n"
    php -d memory_limit=-1 ./bin/console cache:clear --env ${env}

    echo_info "php -d memory_limit=-1 ./bin/console cache:warmup --env ${env}\n"
    php -d memory_limit=-1 ./bin/console cache:warmup --env ${env}
}

