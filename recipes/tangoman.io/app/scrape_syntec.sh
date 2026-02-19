#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/app",
##   "summary": "Scrape data from \"Syntec\" website",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ]
## }
scrape_syntec() {
    _echo_info "$(_console) app:scrape:syntec --env ${env}\n"
    $(_console) app:scrape:syntec --env ${env}
}

