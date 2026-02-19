#!/bin/sh

## Scan shapecode cron
##
## {
##   "namespace": "development",
##   "depends": [
##     "_echo_info"
##   ]
## }
cron_scan() {
    _echo_info "./bin/console shapecode:cron:scan --env ${env}"
    ./bin/console shapecode:cron:scan --env ${env}
}

