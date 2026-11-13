#!/bin/sh

## Scrape data from "Syntec" website
##
## @namespace recipes/tangoman.io/app
## @depends src/shell/colors/_echo_info src/shell/symfony/_console
## @assumes env
scrape_syntec() {
    _echo_info "$(_console) app:scrape:syntec --env ${env}\n"
    $(_console) app:scrape:syntec --env ${env}
}

