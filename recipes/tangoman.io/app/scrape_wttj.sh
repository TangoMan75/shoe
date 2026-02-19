#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/app",
##   "summary": "Scrape data from \"Welcome to the Jungle\" website",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
scrape_wttj() {
    _echo_info "$(_console) app:scrape:wttj --env ${env}\n"
    $(_console) app:scrape:wttj --env ${env}
}

