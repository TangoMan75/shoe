#!/bin/sh

## Scrape data from "Welcome to the Jungle" website
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console"
##   ]
## }
scrape_wttj() {
    _echo_info "$(_console) app:scrape:wttj --env ${env}\n"
    $(_console) app:scrape:wttj --env ${env}
}

