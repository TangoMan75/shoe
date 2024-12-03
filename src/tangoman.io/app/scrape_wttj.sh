#!/bin/sh

## Scrape data from "Welcome to the Jungle" website
scrape_wttj() {
    echo_info "./bin/console app:scrape:wttj --env ${env}\n"
    ./bin/console app:scrape:wttj --env ${env}
}

