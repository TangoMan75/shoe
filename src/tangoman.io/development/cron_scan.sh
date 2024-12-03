#!/bin/sh

## Scan shapecode cron
cron_scan() {
    echo_info "./bin/console shapecode:cron:scan --env ${env}"
    ./bin/console shapecode:cron:scan --env ${env}
}

