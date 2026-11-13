#!/bin/sh

## Run shapecode cron
##
## @namespace recipes/tangoman.io/development
## @depends src/shell/colors/_echo_info
## @assumes env
cron() {
    _echo_info "./bin/console shapecode:cron:run --env ${env}"
    ./bin/console shapecode:cron:run --env ${env}
}

