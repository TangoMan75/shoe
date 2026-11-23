#!/bin/sh

## List bookmarks
##
## @namespace tests/fixtures/scoped
## @flag <all> [-a|--all] List all bookmarks
## @stdout the list result
list() {
    printf 'list: store=%s output=%s verbose=%s all=%s\n' \
        "${store}" "${output}" "${verbose}" "${all}"
}

