#!/bin/sh

## Scrape data from "Syntec" website
scrape_syntec() {
    echo_info "./bin/console app:scrape:syntec --env ${env}\n"
    ./bin/console app:scrape:syntec --env ${env}
}

