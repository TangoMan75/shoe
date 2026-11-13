#!/bin/sh

## Scan shapecode cron
##
## @namespace recipes/tangoman.io/development
## @depends src/shell/colors/_echo_info
## @assumes env
cron_scan() {
    _echo_info "./bin/console shapecode:cron:scan --env ${env}"
    ./bin/console shapecode:cron:scan --env ${env}
}

