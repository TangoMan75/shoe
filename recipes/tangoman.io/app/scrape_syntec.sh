#!/bin/sh

## Scrape data from "Syntec" website
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console"
##   ]
## }
scrape_syntec() {
    _echo_info "$(_console) app:scrape:syntec --env ${env}\n"
    $(_console) app:scrape:syntec --env ${env}
}

