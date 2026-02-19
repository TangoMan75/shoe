#!/bin/sh

## Run shapecode cron
##
## {
##   "namespace": "development",
##   "depends": [
##     "_echo_info"
##   ]
## }
cron() {
    _echo_info "./bin/console shapecode:cron:run --env ${env}"
    ./bin/console shapecode:cron:run --env ${env}
}

