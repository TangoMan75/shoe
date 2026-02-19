#!/bin/sh

## Scrape data
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console"
##   ]
## }
scrape() {
    _echo_info "$(_console) app:scrape --env ${env}\n"
    $(_console) app:scrape --env ${env}
}

