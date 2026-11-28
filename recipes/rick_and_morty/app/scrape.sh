#!/bin/sh

## Scrape data
##
## @namespace recipes/rick_and_morty/app
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/symfony/_console.sh
## @assumes env
scrape() {
    _echo_info "$(_console) app:scrape --env \"${env}\"\n"
    $(_console) app:scrape --env "${env}"
}

