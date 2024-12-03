#!/bin/sh

## Run shapecode cron
cron() {
    echo_info "./bin/console shapecode:cron:run --env ${env}"
    ./bin/console shapecode:cron:run --env ${env}
}

