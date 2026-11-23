#!/bin/sh

## Add a bookmark
##
## @namespace tests/fixtures/scoped
## @option {str} <name> [-n|--name] /^[A-Za-z0-9._-]+$/ (default:"") Bookmark name
## @option {str} <url> [-u|--url] /^https?:\/\/[^[:space:]]+$/ (default:"") Bookmark URL
## @flag <force> [-f|--force] Skip confirmation prompts
## @stdout the add result
add() {
    printf 'add: store=%s output=%s verbose=%s name=%s url=%s force=%s\n' \
        "${store}" "${output}" "${verbose}" "${name}" "${url}" "${force}"
}

