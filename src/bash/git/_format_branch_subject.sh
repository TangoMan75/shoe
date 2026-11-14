#!/bin/sh

## Format a branch subject
##
## Formats a branch subject by removing type prefix, removing ticket prefix, converting to lowercase, replacing special characters with underscores, and removing trailing underscores.
##
## @namespace src/bash/git
## @requires printf sed tr
## @param {str} <SUBJECT> (required) The branch subject to format.
_format_branch_subject() {
    printf '%s' "$1" \
        | tr -s ' ' \
        | sed -e 's/^build\///' \
              -e 's/^chore\///' \
              -e 's/^ci\///' \
              -e 's/^docs\///' \
              -e 's/^feat\///' \
              -e 's/^fix\///' \
              -e 's/^perf\///' \
              -e 's/^refactor\///' \
              -e 's/^style\///' \
              -e 's/^test\///' \
        | sed 's/[A-Z]\{1,\}-[0-9]\{1,\}\///' \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9_\/-]/_/g' \
        | sed 's/_*$//'
}

