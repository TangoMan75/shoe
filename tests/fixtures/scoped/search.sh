#!/bin/sh

## Search bookmarks
##
## @namespace tests/fixtures/scoped
## @option {str} <term> [-t|--term] (default:"") Search term
## @stdout the search result
search() {
    printf 'search: store=%s output=%s verbose=%s term=%s\n' \
        "${store}" "${output}" "${verbose}" "${term}"
}

