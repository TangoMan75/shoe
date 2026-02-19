#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/app",
##   "summary": "Scrape data",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ]
## }
scrape() {
    _echo_info "$(_console) app:scrape --env ${env}\n"
    $(_console) app:scrape --env ${env}
}

